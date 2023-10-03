import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:provider/provider.dart';

const double logoPortion = 0.4;
const double headerPortion = 1 - logoPortion;
const double logoWidth = 240;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late bool _isLoading = false;
  late bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: OrientationBuilder(
        builder: (_, orientation) {
          final bool isPortraitMode = orientation == Orientation.portrait;
          if (isPortraitMode) {
            return Column(
                  children: _buildWidgets(
                    isPortraitMode: isPortraitMode,
                    height: size.height,
                    width: size.width,
                    onPressed: () {
                      _signIn(context: context);
                    },
                  ),
                );
          } else {
            return Row(
                  children: _buildWidgets(
                    isPortraitMode: isPortraitMode,
                    height: size.height,
                    width: size.width,
                    onPressed: () {
                      _signIn(context: context);
                    },
                  ),
                );
          }
        },
      ),
    );
  }

  void _signIn({required BuildContext context}) async {
    setState(() {
      _isLoading = true;
    });

    await Connectivity().checkConnectivity().then((connectivityStatus) async {
      if (connectivityStatus == ConnectivityResult.none) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar(
            content: const Text(noInternetConnectionWarningText),
            showCloseIcon: true,
          )).closed.then((value) => setState(() {
            _isLoading = false;
            _isSuccess = false;
          }));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              title: Text(
                permissionsDialogTitle,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 5,
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 12.0, 12, 12.0),
              children:[
                _buildDialogContent(),
                verticalSpace(height: 16.0),
                _buildDialogActions(),
              ],
            );
          },
        ).then((value) {
          if (value == null) {
            setState(() {
              _isLoading = false;
              _isSuccess = false;
            });
          }
        });
      }
    });
  }

  List<Widget> _buildWidgets({
    required bool isPortraitMode,
    required double width,
    required double height,
    required VoidCallback onPressed,
  }) {
    return [
      Container(
        height: isPortraitMode ? height * logoPortion : height,
        alignment: Alignment.center,
        width: isPortraitMode ? width : width * logoPortion,
        padding: const EdgeInsets.all(24.0),
        child: Image.asset(
          '${resourcePath}rsl_logo.png',
          width: logoWidth,
        ),
      ),
      Container(
        width: isPortraitMode ? width : width * headerPortion,
        height: isPortraitMode ? height * headerPortion : height,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: appThemeColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPortalHeader(),
            _buildSignInSubHeader(),
            _buildPortalSignIn(onPressed: onPressed),
          ],
        ),
      ),
    ];
  }

  Widget _buildPortalHeader() {
    return const Column(
      children: [
        Icon(
          Icons.school,
          color: Colors.white,
          size: 50.0,
        ),
        SizedBox(height: 20.0),
        Text(
          signInHeader,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInSubHeader() {
    return const SizedBox(
      width: 250,
      child: Center(
        child: Text(
          signInSubHeader,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPortalSignIn({required VoidCallback onPressed}) {
    bool shouldSignIn = (_isLoading || _isSuccess);
    return OutlinedButton(
      onPressed: !shouldSignIn ? onPressed : null,
      style: OutlinedButton.styleFrom(
        shape: !shouldSignIn ? const StadiumBorder() : const CircleBorder(),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: !shouldSignIn ? 5.0 : 10.0),
        backgroundColor: Colors.white,
        maximumSize: const Size.fromWidth(300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading)
            const SpinKitRing(color: appThemeColor, lineWidth: 5, size: 40)
          else if (_isSuccess)
            const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
              size: 40,
            )
          else
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    '${resourcePath}google_logo.png',
                  ),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 10.0),
                Text(
                  signInButtonText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildDialogContent() {
    return Column(
      children: [
        Text(
          permissionsDialogContent[0],
          style: Theme.of(context).textTheme.bodySmall,
        ),
        verticalSpace(height: 5),
        Text(
          permissionsDialogContent[1],
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildDialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _isLoading = false;
            });
            Navigator.pop(context, false);
          },
          child: const Text(cancelDialogActionText),
        ),
        horizontalSpace(width: sectionLabelSpacingWidth),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, false);
            await Provider.of<SignInViewModel>(context, listen: false).signIn();
            setState(() {
              _isLoading = false;
              if (FirebaseAuth.instance.currentUser != null) {
                _isSuccess = true;
              }
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: appThemeColor,
            foregroundColor: Colors.white,
          ),
          child: const Text(continueDialogActionText),
        ),
      ],
    );
  }
}
