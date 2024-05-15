#ifndef FLUTTER_PLUGIN_YOUTUBE_SCRAPER_PLUGIN_H_
#define FLUTTER_PLUGIN_YOUTUBE_SCRAPER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace youtube_scraper {

class YoutubeScraperPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  YoutubeScraperPlugin();

  virtual ~YoutubeScraperPlugin();

  // Disallow copy and assign.
  YoutubeScraperPlugin(const YoutubeScraperPlugin&) = delete;
  YoutubeScraperPlugin& operator=(const YoutubeScraperPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace youtube_scraper

#endif  // FLUTTER_PLUGIN_YOUTUBE_SCRAPER_PLUGIN_H_
