import 'package:flutter/material.dart';
import 'package:mineralflow/strings/strings.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_text_button.dart';
import 'package:mineralflow/view/pages/batch_type.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});
  bool smallScreen = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    smallScreen = height < 700 ? true : false;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: smallScreen ? 20 : 80.0),
            child: Text("Select Batch Category", style: TextFonts.titles),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: smallScreen ? 100 : 140),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BoxTextButton(title: Strings.plantSample),
                  const SizedBox(width: 130),
                  BoxTextButton(title: Strings.geologySample),
                ],
              ),
              // const SizedBox(height: 80,),
              // AddNewButton(title: "Add New Category", func: (){})
            ],
          ),
        ],
      ),
    );
  }
}
