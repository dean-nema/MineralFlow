import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

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
