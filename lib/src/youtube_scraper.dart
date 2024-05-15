import 'package:youtube_scraper/src/model/video_info.dart';
import 'model/subtitle_line.dart';
import 'model/subtitle_track.dart';
import 'youtube_scraper_http_client.dart';
import 'youtube_scraper_impl.dart';

/// YouTube caption/subtitle scraper.
///
/// In order to get subtitles of a YouTube video, you first
/// need to get caption tracks via [getCaptionTracks],
/// and pass a caption track to [getSubtitles]:
///
/// ```dart
/// final captionScraper = YouTubeSubtitleScraper();
///
/// final captionTracks = await captionScraper.getCaptionTracks('example-video-url');
/// final subtitles = await captionScraper.getSubtitles(captionTracks.first);
///
/// for (final subtitleLine in subtitles) {
///   print('${subtitleLine.start} - ${subtitleLine.duration} - ${subtitleLine.text}');
/// }
/// ```
abstract class YoutubeScraper {
  /// {@macro YouTubeCaptionScraperImpl}
  factory YoutubeScraper({
    YouTubeScrapeHttpClient? httpClient,
  }) {
    return YouTubeScraperImpl(httpClient: httpClient);
  }

  /// Gets caption tracks of the video on [videoId].
  Future<List<SubtitleTrack>> getCaptionTracks(String videoId);

  /// Gets subtitles based on [captionTrack.baseUrl].
  ///
  /// You can get [captionTrack] by calling [getCaptionTracks] with
  /// the video URL you're interested in.
  Future<List<SubtitleLine>> getSubtitlesTrack(SubtitleTrack captionTrack);

  Future<List<SubtitleLine>> getSubtitles(
      {required String videoId, String languageCode = 'en'});

  Future<VideoInfo> getVideoInfo({required String videoId});
}
