import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class TextGroupColumn extends StatelessWidget {
  final title, subtitle;
  const TextGroupColumn(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextLabell(
            text: title,
            color: Constanst.fgPrimary,
            weight: FontWeight.w500,
            size: 16),
        const SizedBox(height: 4),
        TextLabell(
            text: subtitle,
            color: Constanst.fgSecondary,
            weight: FontWeight.w400,
            size: 14),
      ],
    );
  }
}

class TextGroupColumn2 extends StatelessWidget {
  final title, subtitle;
  const TextGroupColumn2(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextLabell(
            text: subtitle,
            color: Constanst.fgSecondary,
            weight: FontWeight.w400,
            size: 14),
        const SizedBox(height: 4),
        TextLabell(
            text: title,
            color: Constanst.fgPrimary,
            weight: FontWeight.w500,
            size: 16),
      ],
    );
  }
}
