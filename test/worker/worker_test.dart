import 'package:flutter_test/flutter_test.dart';
import 'package:p_lyric/provider/utils/waiter.dart';
import 'package:get/get.dart';

void main() {
  test('wait', () async {
    final count = 0.obs;
    int? result = -1;
    wait(count, (dynamic _) {
      result = _ as int?;
    }, time: const Duration(milliseconds: 100));

    count.value++;
    count.value++;
    count.value++;
    count.value++;
    await Future.delayed(Duration.zero);
    expect(1, result);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(4, result);
  });
}