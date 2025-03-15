 import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/proceed_btn.dart';
import 'package:mineralflow/view/components/special_description_box.dart';
import 'package:mineralflow/view/pages/sample_stickers.dart';

class SpecialSmaple extends StatelessWidget {
  const SpecialSmaple({super.key});

  @override
  Widget build(BuildContext context) {
      final width = MediaQuery.sizeOf(context).width;
      final height = MediaQuery.sizeOf(context).height;
    return  Scaffold( 
     backgroundColor: Colours.mainBg,
     appBar: Appbar(),
     body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
          children: [
              Expanded(
                child: Text("Special Sample Description", style: TextFonts.titles),
                ),
                Expanded(
                flex:6,
                child: Container( 
                width: width,
                height: height * 0.5,
                child: Row(
                children: [
                  Expanded(flex:5,  child: Center(child: SpecialDescriptionBox(title: "Sample 1 Description"))),
                  Expanded(child: AddNewButton(title: "Additional Sample", func: (){}))
                ],),
                ),
              ),
              Expanded(child: ProceedBtn(func: (){
                   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  SampleStickers()),
      );
   
                  }))
          ],
          ),
        ) ,
     ),
    );
  }
}
