import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class Stickers extends StatelessWidget {
  Stickers({super.key});

  TextEditingController descriptionController = TextEditingController();
  TextEditingController massController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center, // Centers everything
          children: [
            Text("Morupule Coal Mine", style: TextFonts.stickerTxt),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                width: 200,
                  height: 20,
                  child: Image.asset("assets/images/barcode.png"),
                ),
                Text("Feed", style: TextFonts.stickerTxt2),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(child: Text("2320981743", style: TextFonts.stickerTxt)),
                ),
                Expanded(
                flex: 2,
                  child: Text("Date:  12/02/2025", style: TextFonts.stickerTxt),
                ),
              ],
            ),
            Divider(),
            SizedBox(
            height: 80,
              child: Row(
                children: [
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Plant: CHPP", style: TextFonts.stickerTxt),
                      Text("Type: Routine Sample", style: TextFonts.stickerTxt),
                      Text("Routine: 2 Hourly", style: TextFonts.stickerTxt),
                    ],
                  ),
                  VerticalDivider(),
                  Column(
                    children: [
                      Text("Mass: 8.92", style: TextFonts.stickerTxt),
                      Text("Description: Pulp", style: TextFonts.stickerTxt),
                      Text("Location: West Wing", style: TextFonts.stickerTxt),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
