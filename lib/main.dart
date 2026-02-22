import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import 'change_notifiers/notes_provider.dart';
import 'change_notifiers/registration_controller.dart';
import 'core/constants.dart';
import 'firebase_options.dart';
import 'pages/main_page.dart';
import 'pages/registration_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationController()),
      ],
      child: MaterialApp(
        title: 'Awesome Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: background,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                backgroundColor: background,
                titleTextStyle: const TextStyle(
                  color: primary,
                  fontSize: 32,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        home: StreamBuilder<User?>(
          stream: AuthService.userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && AuthService.isEmailVerified) {
              // ONLY CHANGE: Add this key to force rebuild on user change
              return MainPage(key: ValueKey(snapshot.data!.uid));
            } else {
              return const RegistrationPage();
            }
          },
        ),
      ),
    );
  }
}