// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText({
    super.key,
    this.iconSize = 40,
    this.iconText = 'Button',
    this.iconTextSize = 16,
    this.icon = Icons.file_copy,
  });

  final double iconSize;
  final String iconText;
  final double iconTextSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
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
