import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/strings/strings.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/plant_details.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  Appbar({super.key});
  bool smallScreen = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    smallScreen = width < 1866 ? true : false;

    return AppBar(
      toolbarOpacity: 0.6,
      backgroundColor: Colours.border,
      title: Row(
        children: [
          Image.asset("assets/images/logo2.png", height: 40),
          const SizedBox(width: 20),
          Text(
            "Mineral Flow",
            style: GoogleFonts.poppins(fontSize: 30, color: Colors.white),
          ),
          smallScreen ? SizedBox() : const SizedBox(width: 90),
          smallScreen
              ? SizedBox()
              : Text(
                "Registration of Samples",
                style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
              ),
        ],
      ),
      actions: [appBarLeft(smallScreen: smallScreen)],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class appBarLeft extends StatelessWidget {
  bool smallScreen;
  appBarLeft({super.key, required this.smallScreen});

  void showSnackBar(BuildContext context, double width, double height) {
    final snackBar = SnackBar(
      content: Text(
        'Width is $width and 60% is ${width * 0.6} \n Width is $height and 60% is ${height * 0.6} ',
      ),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).hideCurrentSnackBar(); // Dismiss the snackbar
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: smallScreen? width * 0.7: width * 0.6,
        height: 50,
        decoration: BoxDecoration(
          color: Colours.mainBg,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              smallScreen
                  ? SizedBox()
                  : TextButton(
                    onPressed: () {
                      Data.cleanUp();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryPage()),
                      );
                    },
                    child: Text("Add Batch Samples", style: TextFonts.normal),
                  ),
              const SizedBox(width: 14),
              TextButton(
                onPressed: () {
                  Data.cleanUp();
                  BatchSamplesModel model = BatchSamplesModel();
                  model.category = BatchCategory(Strings.plantSample);
                  Data.batches.add(model);
                  Data.currentBatchID = model.batchID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BatchType()),
                  );
                },
                child: Text("Add ${Strings.plantSample}s", style: TextFonts.normal),
              ),
              const SizedBox(width: 14),
              TextButton(
                onPressed: () {
                  Data.cleanUp();
                  BatchSamplesModel model = BatchSamplesModel();
                  model.category = BatchCategory(Strings.geologySample);
                  Data.batches.add(model);
                  Data.currentBatchID = model.batchID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantDetails()),
                  );
                },
                child: Text("Add ${Strings.geologySample}s", style: TextFonts.normal),
              ),
              const SizedBox(width: 14),

              TextButton(
                onPressed: () {
                  Data.cleanUp();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisteredSample()),
                  );
                },
                child: Text("Registered Samples", style: TextFonts.normal),
              ),
              const SizedBox(width: 14),
              Center(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colours.text),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(width: 5),
                        Text("Admin User", style: TextFonts.normal),
                        Icon(Icons.person),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
