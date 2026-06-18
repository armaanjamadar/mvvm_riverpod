import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod_movies_app/screens/splash_screen.dart';
import 'package:mvvm_riverpod_movies_app/view_models/theme_provider.dart';
import 'constants/my_theme_data.dart';
import 'enums/theme_enums.dart';
import 'services/init_getit.dart';
import 'services/navigation_service.dart';

void main() {
  setupLocator(); // Initialize GetIt
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    await dotenv.load(fileName: "assets/.env");
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      theme: themeState == ThemeEnums.dark ?
        MyThemeData.darkTheme :
        MyThemeData.lightTheme,
      home: const SplashScreen(),
    );
  }
}
