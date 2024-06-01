import 'package:flutter/material.dart';
import 'package:projek/tema/theme_notifier.dart';
import 'package:provider/provider.dart';

class TemaPage extends StatelessWidget {
  const TemaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan Tema',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigasi ke halaman sebelumnya
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Ubah tema aplikasi
            ThemeNotifier themeNotifier =
                Provider.of<ThemeNotifier>(context, listen: false);
            themeNotifier.toggleTheme();
            Navigator.pop(context);
          },
          child: const Text('Ubah Tema'),
        ),
      ),
    );
  }
}
