import 'package:flutter/material.dart';

class LupaScreen extends StatefulWidget {
  @override
  _LupaScreenState createState() => _LupaScreenState();
}

class _LupaScreenState extends State<LupaScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
 return Scaffold(
      backgroundColor: const Color(0xFFF1F8FF),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 50, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF49A2F4),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Text(
                    'Ubah Kata Sandi',
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      color: Color(0xFF1284EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Lupa Kata Sandi',
                    style: TextStyle(
                      fontFamily: 'fonts/Inter-Black.ttf',
                      color: Color(0xFF1284EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                      'Ubah kata sandi dengan verifikasi email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'fonts/Inter-Black.ttf',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Container(
                        width: 400,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1.00, -1.00),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                              Expanded(
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      hintText: 'Alamat Email',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {

                         },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(340, 60),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              97, 0, 97, 0),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'fonts/Inter-Bold.ttf',
                          ),
                          backgroundColor: Colors.blue.shade400,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Kirim Link"),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}