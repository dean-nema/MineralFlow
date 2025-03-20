import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/strings/strings.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/plant_details.dart';

class BoxTextButton extends StatelessWidget {
  final String title;
   BoxTextButton({super.key, required this.title});

  bool smallScreen = false;
  @override
  Widget build(BuildContext context) {
          final height = MediaQuery.sizeOf(context).height;
    smallScreen = height < 800 ? true : false;
    return Container(
      width:  250,
      height: smallScreen? 150: 250,
      decoration: BoxDecoration(
        color: Colours.bg2,
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
          backgroundColor: Colours.bg2, // Background color
          foregroundColor:
              Colors.transparent, // Prevents ripple color interference
          padding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22), // Match Container's radius
          ),
          elevation: 0, // Disable default shadow (we use BoxShadow instead)
        ),
        onPressed: () {
         Data.cleanUp();
          BatchSamplesModel model = BatchSamplesModel();
          model.category = BatchCategory(title);
          Data.batches.add(model);
          Data.currentBatchID = model.batchID;
          switch (title) {
            case Strings.plantSample:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BatchType()),
              );
              break;
            case Strings.geologySample:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PlantDetails()),
              );
              break;
            default:
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(title, style: TextFonts.buttonTitles),
          ),
        ),
      ),
    );
  }
}
