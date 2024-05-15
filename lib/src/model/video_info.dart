
class VideoInfo {
  String? videoId;
  String? title;
  String? lengthSeconds;
  List<String>? keywords;
  String? channelId;
  bool? isOwnerViewing;
  String? shortDescription;
  bool? isCrawlable;
  Thumbnail? thumbnail;
  bool? allowRatings;
  String? viewCount;
  String? author;
  bool? isPrivate;
  bool? isUnpluggedCorpus;
  bool? isLiveContent;
  List<String> languageSupport = [];

  VideoInfo(
      {this.videoId,
        this.title,
        this.lengthSeconds,
        this.keywords,
        this.channelId,
        this.isOwnerViewing,
        this.shortDescription,
        this.isCrawlable,
        this.thumbnail,
        this.allowRatings,
        this.viewCount,
        this.author,
        this.isPrivate,
        this.isUnpluggedCorpus,
        this.isLiveContent});

  VideoInfo.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    title = json['title'];
    lengthSeconds = json['lengthSeconds'];
    keywords = json['keywords'].cast<String>();
    channelId = json['channelId'];
    isOwnerViewing = json['isOwnerViewing'];
    shortDescription = json['shortDescription'];
    isCrawlable = json['isCrawlable'];
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    allowRatings = json['allowRatings'];
    viewCount = json['viewCount'];
    author = json['author'];
    isPrivate = json['isPrivate'];
    isUnpluggedCorpus = json['isUnpluggedCorpus'];
    isLiveContent = json['isLiveContent'];
  }
}

class Thumbnail {
  List<Thumbnails>? thumbnails;

  Thumbnail({this.thumbnails});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    if (json['thumbnails'] != null) {
      thumbnails = <Thumbnails>[];
      json['thumbnails'].forEach((v) {
        thumbnails!.add(Thumbnails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Thumbnails {
  String? url;
  int? width;
  int? height;

  Thumbnails({this.url, this.width, this.height});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
