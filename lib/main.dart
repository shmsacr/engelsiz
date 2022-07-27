import 'package:engelsiz/controller/auth_controller.dart';
import 'package:engelsiz/firebase_options.dart';
import 'package:engelsiz/ui/screens/dashboard.dart';
import 'package:engelsiz/ui/screens/login/login_screen.dart';
import 'package:engelsiz/ui/screens/message/app.dart';
import 'package:engelsiz/ui/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);
  final client = StreamChatClient(streamKey);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return StreamChatCore(client: client, child: child!);
      },
      home: ref.watch(userProvider) != null
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}
