import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cinform Online News',
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Optional subtitle
            // Text(
            //   'Seu Jornal de Notícias',
            //   style: GoogleFonts.roboto(
            //     fontSize: 16,
            //     fontWeight: FontWeight.normal,
            //     color: Colors.grey,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(height: 20),
            // Optional loading indicator
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
