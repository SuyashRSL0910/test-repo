import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  Future<User?> _getUserData(BuildContext context) {
    return Future(() => FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Column(
        children: [
          verticalSpace(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: FutureBuilder<User?>(
                    future: _getUserData(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final displayName = snapshot.data!.displayName;
                        final username =
                        displayName != null ? displayName.split(' ').first : 'User';
                        return Column(children: [
                          getWelcomeHeader(welcomeLabel, context),
                          getWelcomeHeader(username, context),
                        ],);
                      }
                      return Container();
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: Image.asset(
                      "${resourcePath}welcome_image.png",
                      fit: BoxFit.fitHeight,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(height: sectionHeaderSpacingHeight),
          Text(
            welcomeSectionDescription,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          verticalSpace(height: sectionHeaderSpacingHeight),
          const Divider(
            color: appThemeColor,
            thickness: 1,
            endIndent: 20,
            indent: 20,
            height: 1,
          ),
        ],
      ),
    );
  }
}
