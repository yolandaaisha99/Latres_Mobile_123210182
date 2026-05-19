import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/tv_show.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'widgets/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(TvShowAdapter());
  await FavoriteService.init();

  final isLoggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NontonSkuy!',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
