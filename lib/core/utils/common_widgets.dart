import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/dart_utils.dart';

/// Loading Widget
Widget loadingState({double? height = cardHeight}) {
  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: double.infinity,
      height: height,
      child: SpinKitWave(
        size: 20.0,
        itemBuilder: (context, index) {
          return Container(
            color: appThemeColor,
          );
        },
      ),
    ),
  );
}

/// Section
Widget sectionHeader(
  String headerText, {
  required BuildContext context,
  bool addTextDecoration = false,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    headerText,
    style: addTextDecoration
        ? Theme.of(context).textTheme.titleLarge!.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.black,
              shadows: [
                const Shadow(color: Colors.black, offset: Offset(0, -5))
              ],
              color: Colors.transparent,
            )
        : Theme.of(context).textTheme.titleLarge,
    maxLines: 2,
    textAlign: textAlign,
  );
}

Widget sectionBody(
  String bodyText, {
  required BuildContext context,
  int maxLines = 1,
  TextAlign? textAlign,
}) {
  return Text(
    bodyText,
    style: Theme.of(context).textTheme.bodyMedium,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    textAlign: textAlign,
  );
}

Widget sectionDivider({Color color = appThemeColor, double thickness = 1.0}) {
  return Divider(
    color: color,
    height: thickness,
    thickness: thickness,
  );
}

/// App bar
PreferredSizeWidget appBar({shouldAddBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          shouldAddBackButton
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_outlined),
                )
              : IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
          SizedBox(
            width: 70,
            child: Image.asset('${resourcePath}rsl_logo.png'),
          ),
          if (!isPortraitMode(context)) const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(appBarName, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }),
  );
}

/// Footer Widget
final footer = Builder(builder: (context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      color: footerBgColor,
      padding: const EdgeInsets.symmetric(
        horizontal: cardPadding * 2,
        vertical: cardPadding,
      ),
      child: Text(
        footerText,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: bodyTextColor,
              fontWeight: FontWeight.normal,
            ),
      ),
    ),
  );
});

/// Error Widget
Widget errorState({required Function refresh}) {
  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(cardContentPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(errorFetching, textAlign: TextAlign.center),
                IconButton(
                  onPressed: () {
                    refresh();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Empty Widget
Widget emptyState({required String emptyStateMessage}) {
  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(cardContentPadding),
            child: Center(
              child: Text(emptyStateMessage, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    ),
  );
}

// Toast
SnackBar snackBar({required Widget content, bool showCloseIcon = false}) {
  return SnackBar(
    content: content,
    behavior: SnackBarBehavior.floating,
    showCloseIcon: showCloseIcon,
    closeIconColor: Colors.white,
  );
}

/// Spacing Widgets
Widget verticalSpace({double height = sectionSpacingHeight}) =>
    _space(height: height);

Widget horizontalSpace({double width = sectionSpacingWidth}) =>
    _space(width: width);

Widget _space({double? height, double? width}) =>
    SizedBox(height: height, width: width);

Widget getWelcomeHeader(String welcomeText, BuildContext context) {
  return Center(
    child: Text(
      welcomeText,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 20,
          ),
      maxLines: 2,
    ),
  );
}

RoundedRectangleBorder cardBorder() {
  return RoundedRectangleBorder(
    side: BorderSide(color: cardBorderColor!, width: cardBorderWidth),
    borderRadius: BorderRadius.circular(cardRadius),
  );
}

// Dialogs

Future<DateTime?> showDatePickerDialog(BuildContext context) {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
    errorFormatText: dateDialogFormatText,
    fieldLabelText: dateDialogFieldLabelText,
    errorInvalidText: dateDialogErrorInvalidText,
  );
}

Future<String?> showTimePickerDialog(BuildContext context) async {
  TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    errorInvalidText: timeErrorInvalidText,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );
    },
  );

  String? time;
  if (timeOfDay != null && context.mounted) {
    final localizations = MaterialLocalizations.of(context);
    time = localizations.formatTimeOfDay(timeOfDay, alwaysUse24HourFormat: false);
  }
  return time;
}
