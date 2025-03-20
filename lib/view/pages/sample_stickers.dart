import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/print_btn.dart';
import 'package:mineralflow/view/components/stickers.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class SampleStickers extends StatelessWidget {
   SampleStickers({super.key});
  bool smallScreen = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
        smallScreen = height < 700 ? true : false;

    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Sample Stickers", style: TextFonts.titles),
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: width,
                  child: Center(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 470,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount:
                          Data.getStickers()
                              .length, // Number of stickers (adjust as needed)
                      itemBuilder: (context, index) {
                        return Stickers(
                          stickerObj: Data.getStickers()[index],
                        ); // Build each Stickers widget
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
              width: 200,
              height: 100,
                child: PrintBtn(
                  title: "Print Stickers",
                  func: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                          backgroundColor: Colours.mainBg,
                            title: Text("Printer"),
                            content: Text("Printing currently unavailable"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
