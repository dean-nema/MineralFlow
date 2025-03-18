import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/batch_type.dart';
import 'package:mineralflow/view/pages/category.dart';
import 'package:mineralflow/view/pages/plant_details.dart';
import 'package:mineralflow/view/pages/registered_sample.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
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
          const SizedBox(width: 90),
          Text(
            "Registration of Samples",
            style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
      actions: [appBarLeft()],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class appBarLeft extends StatelessWidget {
  const appBarLeft({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: width * 0.6,
        height: 50,
        decoration: BoxDecoration(
          color: Colours.mainBg,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
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
                  model.category = BatchCategory("PLANT SAMPLE");
                  Data.batches.add(model);
                  Data.currentBatchID = model.batchID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BatchType()),
                  );
                },
                child: Text("Add Plant Samples", style: TextFonts.normal),
              ),
              const SizedBox(width: 14),
              TextButton(
                onPressed: () {
                    Data.cleanUp();
                  BatchSamplesModel model = BatchSamplesModel();
                  model.category = BatchCategory("GEOLOGY SAMPLE");
                  Data.batches.add(model); Data.currentBatchID = model.batchID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantDetails()),
                  );
                },
                child: Text("Add Geology Samples", style: TextFonts.normal),
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
