import 'package:flutter/material.dart';
import 'package:projek/screens/awalan/daftar_screen.dart';
import 'package:projek/screens/awalan/masuk_screen.dart';

class TampilanAwal extends StatefulWidget {
  const TampilanAwal({super.key});

  @override
  State<TampilanAwal> createState() => _TampilanAwalState();
}

class _TampilanAwalState extends State<TampilanAwal> {
  void _pindah1() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const DaftarScreen();
    }));
  }

  void _pindah2() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MasukScreen();
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffB4DBFE), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: ClipRRect(
                child: Image.asset(
                  'images/hello.png',
                  width: 271,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0.05, 0.87),
              child: Container(
                width: 341,
                height: 310,
                decoration: BoxDecoration(
                  color: const Color(0xFFBADBFA),
                  borderRadius: BorderRadius.circular(41),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Text(
                          'TraveLine',
                          style: TextStyle(
                            fontFamily: 'fonts/Inter-Black.ttf',
                            color: Color(0xFF1284EE),
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        ),
                      ),
                      const Text(
                        'Jelajahi yang Sejati',
                        style: TextStyle(
                          fontFamily: 'fonts/Inter-Black.ttf',
                          color: Color(0xFF196EEE),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                        child: ElevatedButton(
                          onPressed: _pindah2,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsetsDirectional.fromSTEB(100, 0, 100, 0),
                            fixedSize: const Size(340, 60),
                            textStyle: const TextStyle(
                              fontSize: 19,
                              fontFamily: 'fonts/Inter-Bold.ttf',
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade400,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("MASUK"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: ElevatedButton(
                          onPressed: _pindah1,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(340, 60),
                            padding: const EdgeInsetsDirectional.fromSTEB(97, 0, 97, 0),
                            textStyle: const TextStyle(
                              fontSize: 19,
                              fontFamily: 'fonts/Inter-Bold.ttf',
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade400,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("DAFTAR"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
