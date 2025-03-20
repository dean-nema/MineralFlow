import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';
import 'package:mineralflow/view/pages/sample_stickers.dart';

class RegisteredSample extends StatefulWidget {
  const RegisteredSample({super.key});

  @override
  State<RegisteredSample> createState() => _RegisteredSampleState();
}

class _RegisteredSampleState extends State<RegisteredSample> {
  // Dropdown value
  String? _selectedOption = 'All';
  final List<String> _dropdownOptions = ['CHPP', 'CWP', "All"];
  bool smallScreen = false;
  bool extraSmall = false;

  //functions
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'Please Tick the samples you want to generate stickers for, if available.',
      ),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 10),
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
    List<Map<String, dynamic>> data = [];
    switch (_selectedOption) {
      case 'All':
        data = Data.getRegisteredSamples();
        break;
      case 'CHPP':
        data = Data.getRegisteredSamplesCHPP();
        break;
      case 'CWP':
        data = Data.getRegisteredSamplesCWP();
        break;
      default:
    }
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    smallScreen = width > 1200 && width < 1866 ? true : false;
    extraSmall = width < 1200 ? true : false;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Column(
        children: [
          // Header with Dropdown and New Button
          Center(
            child: SizedBox(
              width: width * 0.85,
              height: smallScreen ? height * 0.12 : height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_selectedOption Registered Samples',
                    style: smallScreen ? TextFonts.titles2 : TextFonts.titles,
                  ),
                  const SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedOption,
                    items:
                        _dropdownOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option, style: TextFonts.normal5),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue;
                        // Add filtering logic here if needed
                      });
                    },
                  ),
                  const SizedBox(width: 130),
                  Container(
                    width: 210,
                    height: 70,
                    decoration: BoxDecoration(
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
                            12,
                          ), // Match Container's radius
                        ),
                        elevation:
                            0, // Disable default shadow (using BoxShadow instead)
                      ),

                      onPressed: () {
                        if (Data.hasStickers()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SampleStickers(),
                            ),
                          );
                        } else {
                          showSnackBar(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Print Selected', style: TextFonts.buttonText),
                            Image.asset("assets/images/Printer.png"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // TableView
          Container(
            height: smallScreen || extraSmall ? height * 0.7 : height * 0.6,
            width: smallScreen || extraSmall ? width : width * 0.8,
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
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 13,
                top: 9,
              ),
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => Colours.border,
                    ),
                    dataRowColor: WidgetStateProperty.resolveWith(
                      (states) => Colours.mainBg,
                    ),
                    dividerThickness: 1.0, // Horizontal line thickness
                    horizontalMargin: 0, // Remove extra margins
                    columnSpacing: 10, // Space between columns
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, // Bottom border for last row
                          width: 1.0,
                        ),
                      ),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          ' ',
                          style: TextFonts.normal,
                        ), // Checkbox header
                      ),
                      if (!extraSmall)
                        DataColumn(
                          label: Text('Batch ID', style: TextFonts.normal3),
                        ),

                      DataColumn(
                        label: Text('Sample ID', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Plant Location', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Batch Category', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Mass(g)', style: TextFonts.normal3),
                      ),

                      DataColumn(
                        label: Text('Sample Type', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text(
                          'Sample Category',
                          style: TextFonts.normal3,
                        ),
                      ),

                      DataColumn(
                        label: Text('Batch Type', style: TextFonts.normal3),
                      ),
                      if (!smallScreen && !extraSmall)
                        DataColumn(
                          label: Text('Description', style: TextFonts.normal3),
                        ), // Hide on small screens
                      DataColumn(label: Text('Date', style: TextFonts.normal3)),
                      DataColumn(label: Text('Time', style: TextFonts.normal3)),
                    ],
                    rows:
                        data.map((sample) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: sample['selected'],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      for (var element in Data.batches) {
                                        for (var sampleOfBatch
                                            in element!.samplesDescription!) {
                                          if (sampleOfBatch.sampleID ==
                                              sample['sampleId']) {
                                            sampleOfBatch.isSelected =
                                                value ?? false;
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                              if (!extraSmall)
                                DataCell(
                                  Text(
                                    sample['batchId'],
                                    style: TextFonts.normal,
                                  ),
                                ),
                              DataCell(
                                Text(
                                  sample['sampleId'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              DataCell(
                                Text(
                                  sample['plantLocation'],
                                  style: TextFonts.normal,
                                ),
                              ),

                              DataCell(
                                Text(
                                  sample['batchCategory'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              DataCell(
                                Text(sample['mass'], style: TextFonts.normal),
                              ),

                              DataCell(
                                Text(
                                  sample['sampleType'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              DataCell(
                                Text(
                                  sample['sampleCategory'],
                                  style: TextFonts.normal,
                                ),
                              ),

                              DataCell(
                                Text(
                                  sample['batchType'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              if (!smallScreen && !extraSmall)
                                DataCell(
                                  Text(
                                    sample['description'],
                                    style: TextFonts.normal,
                                  ),
                                ), // Hide on small screens
                              DataCell(
                                Text(sample['date'], style: TextFonts.normal),
                              ),
                              DataCell(
                                Text(sample['time'], style: TextFonts.normal),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
