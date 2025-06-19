import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mineralflow/models/sticker_model.dart';
import 'package:mineralflow/view/Constants/texts.dart';

class Stickers extends StatelessWidget {
    StickerModel stickerObj;
  Stickers({super.key, required this.stickerObj });

  TextEditingController descriptionController = TextEditingController();
  TextEditingController massController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
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
                  height: 70,
                  child: BarcodeWidget(data: stickerObj.barcode, barcode: Barcode.code128()),
                ),
                Text(stickerObj.sampleDescription2, style: TextFonts.stickerTxt2),
              ],
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text("Sample ID: ${stickerObj.id}", style: TextFonts.stickerTxt,), 
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10),
                  child: Text("Date:  ${stickerObj.date}", style: TextFonts.stickerTxt),
                ),
              ],
            ),
            Divider(),
            SizedBox(
            height: 80,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Plant: ${stickerObj.plant}", style: TextFonts.stickerTxt, overflow: TextOverflow.ellipsis,),
                        Text("Type: ${stickerObj.type}", style: TextFonts.stickerTxt,  overflow: TextOverflow.ellipsis),
                        Text("Routine: ${stickerObj.category}", style: TextFonts.stickerTxt,  overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mass: ${stickerObj.mass}", style: TextFonts.stickerTxt),
                      Text("Description: ${stickerObj.sampleDescription}", style: TextFonts.stickerTxt),
                      Text("Location: ${stickerObj.location}", style: TextFonts.stickerTxt),
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
