import 'package:chat_app/src/features/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_app/src/routes/error_route.dart';
import 'route_transition.dart';

class MyAppRouter {
  static final router = GoRouter(
    initialLocation: '/${AppRoute.loginpage}',
    routes: [
      GoRoute(
        name: AppRoute.errorPage,
        path: '/${AppRoute.errorPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const ErrorPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.loginpage,
        path: '/${AppRoute.loginpage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: SigninScreen(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorPage());
    },
  );

  static void clearAndNavigate(BuildContext context, String name) {
    while (context.canPop()) {
      context.pop();
    }
    context.pushReplacementNamed(name);
  }
}

class AppRoute {
  static const String errorPage = 'error-page';
  static const String dashboard = "dashboard-screen";
  static const String product = "product-screen";
  static const String notificationpage = "notification";
  static const String signup = "sign-up-page";
  static const String signauth = "sign-up-auth";
  static const String loginpage = "signin";
  static const String forget = "forget";
  static const String authwrapperpage = "auth-wrapper";
}
