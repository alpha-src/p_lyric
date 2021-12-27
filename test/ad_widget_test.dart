import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:p_lyric/provider/ad_state.dart';
import 'package:p_lyric/widgets/default_container.dart';

void main() {
  testWidgets("광고가 초기화 되지 않으면 `DefaultContainer`의 하단에 광고가 삽입 되지 않는다.",
      (tester) async {
    Get.put(AdState(MobileAds.instance.initialize()));
    await tester.pumpWidget(MaterialApp(
      home: DefaultContainer(
        title: const Text('title'),
        body: const Text('body'),
      ),
    ));

    expect(find.byType(AdWidget), findsNothing);
  });
}
