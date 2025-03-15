import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_button.dart';
import 'package:mineralflow/view/pages/category.dart';

class BatchSample extends StatelessWidget {
  const BatchSample({super.key});
  

  
  @override
  Widget build(BuildContext context) {
      void func(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const  CategoryPage()),
      );
      }
    return Scaffold( 
    backgroundColor: Colours.mainBg,
    appBar: Appbar(),
    body: Center(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
          BoxButton(image: "assets/images/Box.png", caption: "Add Batch Samples", func: func,),
          BoxButton(image: "assets/images/file.png", caption: "View Registered Samples", func: func,)
        ]
    ),
    ),
    ); 
 }
}
