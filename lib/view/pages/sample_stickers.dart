import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/print_btn.dart';
import 'package:mineralflow/view/components/stickers.dart';

class SampleStickers extends StatelessWidget {
  const SampleStickers({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(child: Text("Sample Stickers", style: TextFonts.titles)),
              Expanded(
              flex: 3,
                child: SizedBox(
                width: width,
                  child: Center(
                    child: GridView.builder(
                    gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 374,
                    mainAxisExtent: 190,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    ),
                    itemCount: 6, // Number of stickers (adjust as needed)
                    itemBuilder: (context, index) {
                      return Stickers(); // Build each Stickers widget
                    },
                                      ),
                  ),
                ),
              ),
              Expanded(child: PrintBtn(title: "Print Stickers", func: () {})),
            ],
          ),
        ),
      ),
    );
  }
}
