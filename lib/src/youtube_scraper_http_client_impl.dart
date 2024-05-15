import 'package:http/http.dart' as http;

import 'youtube_scraper_http_client.dart';

/// The default [http]-based implementation of [YouTubeSubtitleScraperHttpClient].
class YouTubeScraperHttpClientImpl
    implements YouTubeScrapeHttpClient {
  @override
  Future<YouTubeScraperHttpResponse> get(Uri url) async {
    final response = await http.get(url);
    return YouTubeScraperHttpResponse(
      body: response.body,
      statusCode: response.statusCode,
    );
  }
}
