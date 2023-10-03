import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_page/features/auth/services/sign_in_view_model.dart';
import 'package:home_page/features/home/data/database_keys.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AccessTokenHelper {

  @Deprecated('Remove usage of context from helper methods')
  late final BuildContext? _context;
  final SignInViewModel? viewModel;

  AccessTokenHelper(this._context, {this.viewModel});

  Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString('accessToken');
    await http.get(Uri.parse('$oauthTokenInfoUrl$accessToken')).then(
      (value) async {
        if (value.statusCode == 200) {
          debugPrint('Token is not expired yet');
        } else {
          debugPrint('Token expired');
          debugPrint('Re-authentication started to get new access token');
          late GoogleSignInAccount? user;
          if (viewModel != null && _context == null) {
            user = await viewModel!.signInSilently();
          } else {
            user = await Provider.of<SignInViewModel>(
              _context!,
              listen: false,
            ).signInSilently();
          }
          if (user != null) {
            final auth = await user.authentication;
            accessToken = auth.accessToken;
            sharedPreferences.setString('accessToken', accessToken!);
          }
        }
      },
    );

    return accessToken;
  }
}
