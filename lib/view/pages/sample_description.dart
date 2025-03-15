import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/add_new_button.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/components/description_box.dart';
import 'package:mineralflow/view/components/proceed_btn.dart';
import 'package:mineralflow/view/components/types_button.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/special_smaple.dart';

class SampleDescription extends StatelessWidget {
  const SampleDescription({super.key});

  @override
  Widget build(BuildContext context) {
    void func() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpecialSmaple()),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text("Sample Description", style: TextFonts.titles),
            ),
            Container(
              width: width,
              height: height * 0.74,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              DescriptionBox(title: "Feed"),
                              DescriptionBox(title: "Discard"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              DescriptionBox(title: "Product"),
                              DescriptionBox(title: "Middling"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Center(child: ProceedBtn(func: func))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
