import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:p_lyric/provider/ad_state.dart';
import 'package:p_lyric/style/color.dart';
import 'package:p_lyric/style/font.dart';
import 'package:p_lyric/views/home_page.dart';

import 'services/bugs_lyrics_scraper.dart';

void main() async {
  NowPlaying.instance.start(getLyricsFromBugs);

  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AdState(MobileAds.instance.initialize()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const iconThemeData = const IconThemeData(color: Colors.white54);
    final themeData = ThemeData(
      iconTheme: iconThemeData,
      primaryTextTheme: poppinsTextTheme.apply(fontFamily: FontFamily.poppins),
    );

    const cardShape = const RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(12.0)),
    );
    const cardTheme = const CardTheme(
      shape: cardShape,
      shadowColor: Colors.black54,
      elevation: 6.0,
    );

    return GetMaterialApp(
      theme: themeData.copyWith(
        brightness: Brightness.light,
        colorScheme: lightColorScheme,
        textTheme: nanumGothicTextTheme.apply(
          fontFamily: FontFamily.nanumGothic,
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        cardTheme: cardTheme.copyWith(color: const Color(0xd6ffffff)),
        popupMenuTheme: const PopupMenuThemeData(
          shape: cardShape,
          color: Colors.white,
        ),
      ),
      darkTheme: themeData.copyWith(
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
        textTheme: nanumGothicTextTheme.apply(
          fontFamily: FontFamily.nanumGothic,
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        cardTheme: cardTheme.copyWith(color: const Color(0xd6121212)),
        popupMenuTheme: const PopupMenuThemeData(
          shape: cardShape,
          color: const Color(0xff121212),
        ),
      ),
      home: const HomePage(),
    );
  }
}
