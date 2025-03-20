import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/box_text2_btn.dart';
import 'package:mineralflow/view/pages/category.dart';

class BatchType extends StatelessWidget {
   BatchType({super.key});

  bool smallScreen = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    smallScreen = height < 800 ? true : false;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: smallScreen?20: 80.0),
              child: Text("Select Batch Type", style: TextFonts.titles),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(height: smallScreen? 100: 140),
                SizedBox(
                  width: width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BoxText2Btn(title: "Routine Samples"),
                      const SizedBox(width: 30),
                      BoxText2Btn(title: "StockPiles"),
                      const SizedBox(width: 30),
                      BoxText2Btn(title: "Special Sample"),
                    ],
                  ),
                ),
                SizedBox(height: smallScreen? 30: 130),
                Container(
                  width: 180,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colours.btn,
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.border, // Background color
                      foregroundColor:
                          Colors
                              .transparent, // Prevents ripple color interference
                      padding: EdgeInsets.zero, // Remove default padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          22,
                        ), // Match Container's radius
                      ),
                      elevation:
                          0, // Disable default shadow (using BoxShadow instead)
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryPage()),
                      );
                    }, // Button action
                    child: Row(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text("Back", style: TextFonts.buttonText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
