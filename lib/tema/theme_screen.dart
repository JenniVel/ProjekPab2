import 'package:flutter/material.dart';
import 'package:projek/tema/theme_notifier.dart';
import 'package:provider/provider.dart';

class TemaPage extends StatelessWidget {
  const TemaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Ubah tema aplikasi
            ThemeNotifier themeNotifier =
                Provider.of<ThemeNotifier>(context, listen: false);
            themeNotifier
                .toggleTheme(); // Menggunakan toggleTheme() untuk mengubah tema
            // Kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
          child: const Text('Ubah Tema'),
        ),
      ),
    );
  }
}
