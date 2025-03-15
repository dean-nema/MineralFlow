import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_text2_btn.dart';
import 'package:mineralflow/view/pages/plant_details.dart';

class BatchType extends StatelessWidget {
  const BatchType({super.key});

  @override
  Widget build(BuildContext context) {
    void func() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlantDetails()),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Text("Select Batch Type", style: TextFonts.titles),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 140),
                SizedBox(
                  width: width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxText2Btn(title: "Routine Samples", func: func,),
                      const SizedBox(width: 30),
                      BoxText2Btn(title: "StockPiles", func: func),
                      const SizedBox(width: 30),
                      BoxText2Btn(title: "Special Sample", func: func),
                    ],
                  ),
                ),
                const SizedBox(height: 130),
                AddNewButton(title: "Add New Type", func: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
