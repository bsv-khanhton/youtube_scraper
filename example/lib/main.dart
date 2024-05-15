import 'package:flutter/material.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final youtubeScraper = YoutubeScraper();

  @override
  void initState() {
    super.initState();
  }

  void loadVideoInfo() async {
    //Get video info
    youtubeScraper.getVideoInfo(videoId: "Ij1o5zGDCeE").then((videoInfo) {
        print("videoInfo: ${videoInfo.title}");
      }).catchError((onError) {
        print("onError: ${onError}");
      });
  }

  void loadSubtitle() async {
    //Get list subtitle
    youtubeScraper.getSubtitles(videoId: "Ij1o5zGDCeE").then((subtitles) {
      for (final subtitle in subtitles) {
        print('${subtitle.start} - ${subtitle.duration} - ${subtitle.text}');
      }
    }).catchError((onError) {
      print("onError: ${onError}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Youtube Scraper'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: loadVideoInfo,
                  child: const Text('Load Video Info')),
              const SizedBox(height: 30),
              InkWell(
                  onTap: loadSubtitle,
                  child: const Text('Load Video Subtitle')),
            ],
          ),
        ),
      ),
    );
  }
}
