import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinform_online/core/utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Dark Theme'),
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
