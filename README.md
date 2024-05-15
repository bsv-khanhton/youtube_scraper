# youtube_scraper
A Dart package that scraper YouTube. No authentication is required.
The youtube_scraper package provides a simple and efficient way to retrieve video information and subtitles from YouTube using the video's ID. This package is designed to facilitate the extraction of essential data for video processing, analysis, and integration into other Flutter applications.

## Features
Retrieve Video Information: Get detailed metadata about a YouTube video including title, description, author, view count, like count, and more.
Fetch Subtitles: Extract subtitles or closed captions from a YouTube video in various languages.
Asynchronous Operations: Leverage asynchronous functions to ensure smooth and responsive application performance.

## Usage
```dart
// Instantiate the scraper.
final youtubeScraper = YoutubeScraper();

// Fetch video info
// video id and language code. Language format https://pub.dev/packages/language_code
youtubeScraper.getVideoInfo(videoId: "XXXXX").then((videoInfo) { 
  print("videoInfo: ${videoInfo.title}");
}).catchError((onError) {
  print("onError: ${onError}");
});

// Fetch the subtitles by providing it with a youtube id. Language default is English
youtubeScraper.getSubtitles(videoId: "XXXXX").then((subtitles) {
  for (final subtitle in subtitles) {
    print('${subtitle.start} - ${subtitle.duration} - ${subtitle.text}');
  }
}).catchError((onError) {
  print("onError: ${onError}");
});

//With XXX is youtube video id
```
## Contributing
Contributions are welcome! Please open issues or submit pull requests for any improvements or features you would like to see.

## License
This project is licensed under the MIT License.