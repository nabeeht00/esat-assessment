import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/core/theme/theme.dart';
import 'package:user_management/data/repository/user_repository.dart';
import 'package:user_management/logic/cubit/user_cubit.dart';
import 'package:user_management/presentation/routes/route_generator.dart';
import 'package:user_management/presentation/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit(UserRepository())..loadUsers()),
      ],
      child: MaterialApp(
        title: "User Management",
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: routeSplash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
