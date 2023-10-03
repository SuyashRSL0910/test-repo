import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/theme/text/text_theme_constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

final lightTheme = ThemeData(
  fontFamily: interFont,
  colorScheme: _colorScheme,
  appBarTheme: _appBarTheme,
  brightness: Brightness.light,
  textTheme: textTheme,
  cardTheme: _cardTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  iconButtonTheme: _iconButtonTheme,
  floatingActionButtonTheme: _floatingActionButtonTheme,
);

final darkTheme = ThemeData(

);

const _colorScheme = ColorScheme.light(
  primary: appThemeColor,
  secondary: appThemeColorAccent,
);

const _appBarTheme = AppBarTheme(
  centerTitle: true,
  elevation: 2.0,
  titleSpacing: 0,
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
  titleTextStyle: titleLarge,
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: appThemeColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ),
);

const _floatingActionButtonTheme = FloatingActionButtonThemeData(
  foregroundColor: Colors.white,
  elevation: 8.0,
);

final _cardTheme = CardTheme(
  elevation: cardElevation,
  margin: EdgeInsets.zero,
  shape: cardBorder(),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    disabledBackgroundColor: disabledAppThemeColor,
    disabledForegroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonBorderRadius),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
);

final _iconButtonTheme = IconButtonThemeData(
  style: IconButton.styleFrom(
    iconSize: 24,
  ),
);
