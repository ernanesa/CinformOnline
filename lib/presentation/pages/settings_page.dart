import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinform_online_news/core/utils/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (bool value) {
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
