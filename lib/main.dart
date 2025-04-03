import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedule_generator/screen/main/main_screen.dart';
import 'package:schedule_generator/theme/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
          colorSchemeSeed: kPrimaryColor,
          useMaterial3: true,
          scaffoldBackgroundColor: Theme.of(context).colorScheme.surface,
          appBarTheme: AppBarTheme(
            backgroundColor: kPrimaryColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryColor.withOpacity(0.2),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
                width: 2,
              ),
            ),
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )))),
      debugShowCheckedModeBanner: false,
      title: 'Content Idea Generator',
      home: MainScreen(),
    );
  }
}
