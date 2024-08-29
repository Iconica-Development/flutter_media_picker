// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText({
    super.key,
    this.width = 150,
    this.iconSize = 40,
    this.iconText = 'Button',
    this.iconTextSize = 16,
    this.icon = Icons.file_copy,
  });

  final double iconSize;
  final double width;
  final String iconText;
  final double iconTextSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
          ),
          Text(
            iconText,
            style: TextStyle(fontSize: iconTextSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
