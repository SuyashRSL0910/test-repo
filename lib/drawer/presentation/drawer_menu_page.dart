import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/drawer/application/drawer_menu_page_view_model.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/common/cache_helper.dart';
import 'package:provider/provider.dart';

class DrawerMenuPage extends StatefulWidget {
  const DrawerMenuPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DrawerMenuPageState();
  }
}

class _DrawerMenuPageState extends State<DrawerMenuPage> {

  Future<User?> _getUserData(BuildContext context) {
    return Future(() => FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _getDrawerHeader(future: _getUserData(context)),
          _getMenuOption(
              title: 'Home',
              icon: Icons.home_sharp,
              pageRoute: homePagePath,
              context: context,
              index: 0),
          _getMenuOption(
              title: 'T200 Training',
              icon: Icons.library_books_outlined,
              pageRoute: t200TrainingPagePath,
              context: context,
              index: 1),
          _getMenuOption(
              title: 'Backend Training',
              icon: Icons.settings_suggest,
              pageRoute: backendTrainingPagePath,
              context: context,
              index: 2),
          _getMenuOption(
              title: 'Event Creation',
              icon: Icons.event,
              pageRoute: eventCreationPagePath,
              context: context,
              index: 3),
          _getMenuOption(
              title: 'Feedback',
              icon: Icons.feedback_outlined,
              pageRoute: feedbackPagePath,
              context: context,
              index: 4),
          _getMenuOption(
              title: 'T200 Statistics',
              icon: Icons.add_chart,
              pageRoute: t200StatisticsPagePath,
              context: context,
              index: 5),
          _getMenuOption(
              title: 'Sign out',
              icon: Icons.logout,
              context: context,
              index: 6),
        ],
      ),
    );
  }

  Widget _getMenuOption({
    required String title,
    required IconData icon,
    String? pageRoute,
    required BuildContext context,
    required index,
  }) {
    return Consumer<DrawerMenuPageViewModel>(builder: (context, viewModel, _) {
      bool isSelected = viewModel.selectedIndex == index;
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
          ),
        ),
        leading: Icon(
          icon,
          size: 28,
          color: Colors.black,
          weight: isSelected ? 400 : 1,
        ),
        onTap: () async {
          if (pageRoute != null) {
            // Close the opened drawer
            Navigator.of(context).pop();
            if (pageRoute != ModalRoute.of(context)?.settings.name) {
              if (pageRoute == homePagePath) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.pushNamed(context, pageRoute);
              }
            }
            viewModel.setSelectedIndex(index);
          } else {
            await Provider.of<SignInViewModel>(context, listen: false).signOut();
            CacheHelper().clearCache();
            viewModel.setSelectedIndex(0);
          }
        },
      );
    });
  }
}

Widget _getDrawerHeader({required Future<User?> future}) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final data = snapshot.data!;
        final photoUrl = data.photoURL?.split('=');
        return UserAccountsDrawerHeader(
          accountName: Text(
            data.displayName!,
            style: const TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            data.email!,
            style: const TextStyle(color: Colors.black),
          ),
          currentAccountPicture: photoUrl != null && photoUrl.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(photoUrl[0]),
                  backgroundColor: Colors.transparent,
                )
              : const CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        );
      }
      return Container();
    },
  );
}
