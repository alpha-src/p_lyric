import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubTitle extends StatelessWidget {
  const SubTitle(
    this.label, {
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 1.0),
        Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
          height: 22 * context.textScaleFactor,
          width: 3,
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: context.textTheme.subtitle1!.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            height: 1.0
          ),
        ),
      ],
    );
  }
}
