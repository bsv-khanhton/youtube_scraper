/// The HTTP client used for getting video info from YouTube.
abstract class YouTubeScrapeHttpClient {
  Future<YouTubeScraperHttpResponse> get(Uri url);
}

/// Response returned by functions of [YouTubeScrapeHttpClient].
class YouTubeScraperHttpResponse {
  YouTubeScraperHttpResponse({
    required this.body,
    required this.statusCode,
  });

  final String body;
  final int statusCode;
}
