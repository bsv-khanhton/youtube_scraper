//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <youtube_scraper/youtube_scraper_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) youtube_scraper_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "YoutubeScraperPlugin");
  youtube_scraper_plugin_register_with_registrar(youtube_scraper_registrar);
}
