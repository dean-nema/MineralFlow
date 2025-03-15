import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/batch_sample.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
    @override
      void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BatchSample()),
      );
    });
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colours.mainBg,
    body:  Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
                 Image.asset("assets/images/logo.png"),
                 const SizedBox(height: 20,),
                 Text("Mineral Flow", style: TextFonts.logoName),
               const SizedBox(height: 15,),
                Text("by TSD LABS", style: TextFonts.logoCaption,),
                const SizedBox(height: 30,),
                CircularProgressIndicator(),               
          ],
      ),
    ),
    );
  }
}
