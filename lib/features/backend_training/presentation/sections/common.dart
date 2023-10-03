import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';

Widget buildSeeMoreButton({
  required double width,
  required Widget seeMorePage,
  required String component,
  required BuildContext context,
}) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => seeMorePage,
                settings: RouteSettings(name: '$seeMorePage'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
          ),
          child: const Text(
            seeMoreButtonText,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
