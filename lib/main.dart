import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/src/features/auth/controller/signin_controller.dart';
import 'package:chat_app/src/features/auth/controller/signup_controller.dart';
import 'package:chat_app/src/features/auth/controller/splash_controller.dart';
import 'package:chat_app/src/features/homepages/controller/friends_controller.dart';
import 'package:chat_app/src/features/homepages/controller/getrequests_controller.dart';
import 'package:chat_app/src/features/homepages/controller/user_controller.dart';
import 'package:chat_app/src/features/profile/controller/profile_controller.dart';
import 'package:chat_app/src/routes/go_route.dart';
import 'package:chat_app/src/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SigninController>(
          create: (_) => SigninController(),
        ),
        ChangeNotifierProvider<SignupProvider>(
          create: (_) => SignupProvider(),
        ),
        ChangeNotifierProvider<SplashProvider>(
          create: (_) => SplashProvider(),
        ),
        ChangeNotifierProvider<RequestProvider>(
          create: (_) => RequestProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<FriendProvider>(
          create: (_) => FriendProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.instance.lightTheme(context),
        routerDelegate: MyAppRouter.router.routerDelegate,
        routeInformationParser: MyAppRouter.router.routeInformationParser,
        routeInformationProvider: MyAppRouter.router.routeInformationProvider,
      ),
    );
  }
}
