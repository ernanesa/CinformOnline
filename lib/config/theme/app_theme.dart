import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue[900],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.black), // Cor para tema CLARO
      titleTextStyle: TextStyle(
        color: Color(0xFF152d71),
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF152d71),
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black, size: 24),
    // Add more customization as needed
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.blueGrey,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueGrey,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white, size: 24),
    // Add more customization as needed
  );
}
