import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState extends GetxController {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => 'ca-app-pub-1985155061746313/2210944410';

  BannerAdListener get bannerAdListener => _bannerAdListener;

  BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: ${ad.adUnitId}, $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (Ad ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdImpression: (Ad ad) => print('Ad impression: ${ad.adUnitId}.'),
  );
}
