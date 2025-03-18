import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_text_button.dart';
import 'package:mineralflow/view/pages/batch_type.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
    backgroundColor: Colours.mainBg,
    appBar: Appbar(),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Text("Select Batch Category", style: TextFonts.titles,),
        ),
        Column(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const SizedBox(height: 140,),

            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                BoxTextButton(title: "PLANT SAMPLE"),
                const SizedBox(width: 130,),
                BoxTextButton(title: "GEOLOGY SAMPLE"),
                ],
             ),
             // const SizedBox(height: 80,),
             // AddNewButton(title: "Add New Category", func: (){})
        ],),
      ],
    )
    );
  }
}
