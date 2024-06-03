import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';

class VerifikasiEmailScreen extends StatefulWidget {
  final String email;

  const VerifikasiEmailScreen({Key? key, required this.email})
      : super(key: key);

  @override
  _VerifikasiEmailScreenState createState() => _VerifikasiEmailScreenState();
}

class _VerifikasiEmailScreenState extends State<VerifikasiEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _kirimVerifikasi();
  }

  void _kirimVerifikasi() async {
    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      print('Email verifikasi dikirim ke ${widget.email}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikasi Email'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Email verifikasi telah dikirim ke ${widget.email}.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MasukScreen()),
                  );
                },
                child: Text('Kembali ke Halaman Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
