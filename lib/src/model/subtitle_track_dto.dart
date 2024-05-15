import '../../youtube_scraper.dart';

class SubtitleTrackDTO {
  const SubtitleTrackDTO({
    required this.baseUrl,
    required this.name,
    required this.languageCode,
  });

  factory SubtitleTrackDTO.fromJson(Map<String, dynamic> json) {
    return SubtitleTrackDTO(
      baseUrl: json['baseUrl'],
      name: json['name'] == null ? '' : json['name']['simpleText'],
      languageCode: json['languageCode'],
    );
  }

  final String baseUrl;
  final String name;
  final String languageCode;

  SubtitleTrack toEntity() => SubtitleTrack(
        baseUrl: baseUrl,
        name: name,
        languageCode: languageCode,
      );
}
