import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class Section extends StatelessWidget {
  const Section({super.key, this.header, required this.children, this.footer});

  final String? header;
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(const Divider(height: 0.5, thickness: 0.5, indent: 16, color: AppColors.separator));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 9),
            child: Text(
              header!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.08,
              ),
            ),
          )
        else
          const SizedBox(height: 22),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.only(top: 9, right: 8),
            child: Text(
              footer!,
              style: const TextStyle(fontSize: 12, color: AppColors.textTertiary, height: 1.4),
            ),
          ),
      ],
    );
  }
}
