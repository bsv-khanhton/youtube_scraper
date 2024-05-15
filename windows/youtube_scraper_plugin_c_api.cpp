#include "include/youtube_scraper/youtube_scraper_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "youtube_scraper_plugin.h"

void YoutubeScraperPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  youtube_scraper::YoutubeScraperPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
