import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/plant_details.dart';

class BoxText2Btn extends StatelessWidget {
  final String title;
  const BoxText2Btn({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
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
          var model = Data.getBatchByID();
          if (model != null) {
            switch (title) {
              case "Routine Samples":
                model.type = Data.batcheTypes[1];
                break;
              case "StockPiles":
                model.type = Data.batcheTypes[2];
                break;
              case "Special Sample":
                model.type = Data.batcheTypes[0];
                break;
              default:
              throw Exception("Error which wasnt supposed to be reached inside BoxText2Btn.dart switch statement line 55");
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlantDetails()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage()),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextFonts.buttonTitles2),
          ),
        ),
      ),
    );
  }
}
