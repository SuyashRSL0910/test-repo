import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_page/analytics/services/analytics_service.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/theme/theme_constants.dart';
import 'package:home_page/core/theme/theme_manager.dart';
import 'package:home_page/drawer/application/drawer_menu_page_view_model.dart';
import 'package:home_page/features/network/application/network_service.dart';
import 'package:home_page/features/network/application/network_view_model.dart';
import 'package:provider/provider.dart';
import 'analytics/services/analytics_observer.dart';
import 'features/features.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInViewModel()),
        ChangeNotifierProvider(create: (context) => DrawerMenuPageViewModel()),
        ChangeNotifierProvider(create: (context) => NetworkViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late final StreamSubscription<User?> _user;
  late final StreamSubscription<ConnectivityResult> _network;

  @override
  void initState() {
    super.initState();
    _setUser();
    _setNetwork();
  }

  void _setUser() {
    _user = FirebaseAuth.instance.authStateChanges().listen((user) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      navigatorKey.currentState!.pushReplacementNamed(
        user != null ? homePagePath : signInPagePath,
      );
    });
  }
  void _setNetwork() {
    _network = NetworkService().connectivityStream.listen((event) {
      if (event == ConnectivityResult.none) {
        Provider.of<NetworkViewModel>(context, listen: false).setNetwork(false);
      } else {
        Provider.of<NetworkViewModel>(context, listen: false).setNetwork(true);
      }
    });
  }

  @override
  void dispose() {
    _user.cancel();
    _network.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, themeManager, _) {
      return MaterialApp(
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? homePagePath
            : signInPagePath,
        navigatorKey: navigatorKey,
        routes: {
          homePagePath: (context) => const HomePage(),
          signInPagePath: (context) => const SignInPage(),
          t200TrainingPagePath: (context) => const T200TrainingPage(),
          backendTrainingPagePath: (context) => const BackendTrainingPage(),
          eventCreationPagePath: (context) => const EventCreationPage(),
          feedbackPagePath: (context) => const FeedbackPage(),
          techSeriesFeedbackPagePath: (context) => const TechSeriesFeedbackPage(),
          t200StatisticsPagePath: (context) => const T200StatisticsPage(),
          formSubmittedPagePath: (context) => const FormResponseSubmittedPage()
        },
        title: appBarName,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeManager.themeMode,
        navigatorObservers: [
          AnalyticsObserver(
            analyticsService: AnalyticsService(
              Provider.of<SignInViewModel>(context, listen: false),
            ),
          ),
        ],
      );
    });
  }
}
