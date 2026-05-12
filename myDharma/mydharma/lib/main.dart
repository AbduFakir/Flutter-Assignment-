import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'views/ai_chat/ai_chat_screen.dart';
import 'views/event_details/event_details_screen.dart';
import 'views/home/app_shell.dart';
import 'views/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyDharmaApp());
}

class MyDharmaApp extends StatelessWidget {
  const MyDharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/': (context) {
            final index = ModalRoute.of(context)?.settings.arguments;
            return AppShell(initialIndex: index is int ? index : 0);
          },
          AiChatScreen.routeName: (_) => const AiChatScreen(),
          EventDetailsScreen.routeName: (_) => const EventDetailsScreen(),
        },
        initialRoute: '/splash',
      ),
    );
  }
}
