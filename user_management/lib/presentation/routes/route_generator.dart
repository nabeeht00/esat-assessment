import 'package:flutter/material.dart';
import 'package:user_management/presentation/routes/routes.dart';
import 'package:user_management/presentation/screens/splash_screen.dart';
import 'package:user_management/presentation/screens/user/useradd_screen.dart';
import 'package:user_management/presentation/screens/user/useredit_screen.dart';
import 'package:user_management/presentation/screens/user/userlist_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeSplash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case routeUserList:
        return MaterialPageRoute(builder: (_) => const UserListScreen());

      case routeUserAdd:
        return MaterialPageRoute(builder: (_) => const AddUserScreen());

      case routeUserEdit:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => EditUserScreen(user: args["user"]),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text("Unknown Route"))),
    );
  }
}
