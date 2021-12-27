import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  final context = Get.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: Get.textTheme.bodyText2!.copyWith(
        height: 1.6,
        color: Colors.white,
      ),
    ),
    duration: duration,
  ));
}
