import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';

final textTheme = TextTheme(
  titleSmall: titleSmall,
  titleMedium: titleMedium,
  titleLarge: titleLarge,
  bodySmall: bodySmall,
  bodyMedium: bodyMedium,
  labelMedium: labelMedium,
  labelLarge: labelLarge,
);

final titleSmall = TextStyle(
  color: bodyTextColor,
  overflow: TextOverflow.ellipsis,
);

final titleMedium = TextStyle(
  color: bodyTextColor,
  letterSpacing: 1.0,
  overflow: TextOverflow.ellipsis,
);

const titleLarge = TextStyle(
  fontWeight: FontWeight.w600,
  letterSpacing: 1.0,
  overflow: TextOverflow.ellipsis,
  fontSize: 18,
  color: Colors.black,
);

final bodySmall = TextStyle(
  fontSize: formInfoCardContentFontSize,
  letterSpacing: 1.0,
  color: bodyTextColor,
  height: 1.3,
);

final bodyMedium = TextStyle(
  fontSize: 16,
  letterSpacing: 1.0,
  color: bodyTextColor,
  height: 1.3,
);

const labelMedium = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const labelLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
