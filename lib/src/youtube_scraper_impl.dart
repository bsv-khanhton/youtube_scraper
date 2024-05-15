import 'dart:convert';
import 'dart:ui';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:language_code/language_code.dart';
import 'package:youtube_scraper/src/model/video_info.dart';
import '../youtube_scraper.dart';
import 'model/subtitle_track_dto.dart';
import 'youtube_scraper_http_client.dart';

class YouTubeScraperImpl implements YoutubeScraper {
  /// {@template YouTubeCaptionScraperImpl}
  /// The default implementation of [YoutubeScraper].
  ///
  /// [httpClient] is used for performing HTTP operations. The default value
  /// is [YouTubeScraperHttpClientImpl] which uses [http.Client].
  /// This can be useful when using a proxy or using a different implementation
  /// for the HTTP requests (e.g. Dio).
  /// {@endtemplate}
  YouTubeScraperImpl({
    YouTubeScrapeHttpClient? httpClient,
  }) {
    _httpClient = httpClient ?? YouTubeScraperHttpClientImpl();
  }

  late final YouTubeScrapeHttpClient _httpClient;

  String videoURL(String videoId) => "https://www.youtube.com/watch?v=$videoId";

  @override
  Future<List<SubtitleTrack>> getCaptionTracks(String videoId) async {
    final response = await _httpClient.get(Uri.parse(videoURL(videoId)));
    LanguageCodes.en;
    if (response.statusCode == 404) {
      throw const VideoNotFound();
    }

    final data = response.body;
    final hasCaptionTracks = data.contains('captionTracks');
    if (!hasCaptionTracks) {
      throw const CaptionTracksNotFound();
    } else {
      return _parseCaptionTracks(data);
    }
  }

  List<SubtitleTrack> _parseCaptionTracks(String responseBody) {
    const trailingString = ',"audioTracks"';
    final regex = RegExp(
      '("captionTracks":.*}]$trailingString)',
    );
    final match = regex.firstMatch(responseBody);
    final matchedData =
        responseBody.substring(match!.start, match.end - trailingString.length);
    final json = jsonDecode('{$matchedData}');
    final List captionTracks = json['captionTracks'];
    return List.generate(
      captionTracks.length,
      (index) => SubtitleTrackDTO.fromJson(captionTracks[index]).toEntity(),
    );
  }

  @override
  Future<List<SubtitleLine>> getSubtitlesTrack(
      SubtitleTrack captionTrack) async {
    final response = await _httpClient.get(Uri.parse(captionTrack.baseUrl));
    final lines = response.body
        .replaceFirst('<?xml version="1.0" encoding="utf-8" ?><transcript>', '')
        .replaceFirst('</transcript>', '')
        .split('</text>')
        .where((line) => line.trim().isNotEmpty)
        .map(_convertRawLineToSubtitle);

    return lines.toList();
  }

  SubtitleLine _convertRawLineToSubtitle(String line) {
    final startRegex = RegExp(r'start="([\d.]+)"');
    final durationRegex = RegExp(r'dur="([\d.]+)"');

    /// Force unwrapping because [startString] and [durationString] should
    /// always be there.
    final startString = startRegex.firstMatch(line)!.group(1)!;
    final durationString = durationRegex.firstMatch(line)!.group(1)!;

    final start = _parseDuration(startString);
    final duration = _parseDuration(durationString);

    final htmlText = line
        .replaceAll(r'<text.+>', '')
        .replaceAll(r'/&amp;/gi', '&')
        .replaceAll(r'/<\/?[^>]+(>|$)/g', '');

    final text = _stripHtmlTags(htmlText);

    return SubtitleLine(
      start: start,
      duration: duration,
      text: text,
    );
  }

  Duration _parseDuration(String rawDuration) {
    final parts = rawDuration.split('.');
    final seconds = int.parse(parts[0]);
    final milliseconds = parts.length < 2 ? 0 : int.parse(parts[1]);

    return Duration(seconds: seconds, milliseconds: milliseconds);
  }

  String _stripHtmlTags(String html) {
    final document = parse(html);
    final bodyText = document.body!.text;
    final strippedText = parse(bodyText).documentElement!.text;

    return strippedText;
  }

  @override
  Future<List<SubtitleLine>> getSubtitles(
      {required String videoId, String languageCode = 'en'}) async {
    try {
      LanguageCodes.fromLocale(Locale(languageCode));
    } catch (ex) {
      throw const LanguageCodesFormatException();
    }
    List<SubtitleTrack> subTracks = await getCaptionTracks(videoId);
    if (subTracks.isEmpty) {
      throw const CaptionTracksNotFound();
    } else {
      //check language support
      int indexSupportLanguage = -1;
      for (int i = 0; i < subTracks.length; i++) {
        if (subTracks[i].languageCode == languageCode) {
          indexSupportLanguage = i;
          break;
        }
      }
      if (indexSupportLanguage == -1) {
        throw const LanguageCodesNotSupportException();
      } else {
        List<SubtitleLine> subLine =
            await getSubtitlesTrack(subTracks[indexSupportLanguage]);
        return subLine;
      }
    }
  }

  @override
  Future<VideoInfo> getVideoInfo({required String videoId}) async {
    final response = await _httpClient.get(Uri.parse(videoURL(videoId)));
    LanguageCodes.en;
    if (response.statusCode == 404) {
      //page not found
      throw const VideoNotFound();
    }

    final data = response.body;
    final hasCaptionTracks = data.contains('captionTracks');
    if (!hasCaptionTracks) {
      throw const CaptionTracksNotFound();
    } else {
      return _parseVideoInfo(data);
    }
  }

  Future<VideoInfo> _parseVideoInfo(String responseBody) async {
    String videoDetailTag = '"videoDetails":';
    final regexDetail = RegExp(
      '($videoDetailTag{"videoId":.*"isLiveContent":(true|false)})',
    );
    final matchDetail = regexDetail.firstMatch(responseBody);
    final matchedDataDetail = responseBody.substring(
        matchDetail!.start + videoDetailTag.length, matchDetail.end);
    final jsonDetail = jsonDecode(matchedDataDetail);
    VideoInfo videoInfo = VideoInfo.fromJson(jsonDetail);
    List<String> languageSupport = [];
    List<SubtitleTrack> subtitleTrack = _parseCaptionTracks(responseBody);
    if (subtitleTrack.isNotEmpty) {
      for (int i = 0; i < subtitleTrack.length; i++) {
        languageSupport.add(subtitleTrack[i].languageCode);
      }
    }
    videoInfo.languageSupport = languageSupport;
    return videoInfo;
  }
}
