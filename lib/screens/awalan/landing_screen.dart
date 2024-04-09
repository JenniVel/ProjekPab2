import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projek/screens/awalan/tampilan_awal.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  void initState(){
    super.initState();
    mulai();
  }

  mulai()async{
    var durasi = Duration(seconds: 5);
    return Timer(durasi, () { 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
        return TampilanAwal();
      }));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 73, 161, 244),
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'images/ic_logo.png',
          height: 357,
          width: 332,
        ),
      ),
    );
  }
}