import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/app_bar.dart';

class RegisteredSample extends StatefulWidget {
  const RegisteredSample({super.key});

  @override
  State<RegisteredSample> createState() => _RegisteredSampleState();
}

class _RegisteredSampleState extends State<RegisteredSample> {
  // Dropdown value
  String? _selectedOption = 'CHPP';
  final List<String> _dropdownOptions = ['CHPP', 'CWP'];

  // Sample data (replace with your actual data source)
  final List<Map<String, dynamic>> _samples = [
    {
      'selected': true,
      'sampleId': 'S001',
      'description': 'Coal Sample',
      'sampleType': 'Routine',
      'batchType': 'Daily',
      'date': '2025-03-13',
      'time': '14:30',
    },
    {
      'selected': false,
      'sampleId': 'S002',
      'description': 'Water Sample',
      'sampleType': 'Ad-hoc',
      'batchType': 'Weekly',
      'date': '2025-03-14',
      'time': '09:15',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colours.mainBg,
      appBar: Appbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header with Dropdown and New Button
            Center(
              child: Container(
                width: width * 0.8,
                height: height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CHPP Registered Samples', style: TextFonts.titles),
                    const SizedBox(width: 40),
                    DropdownButton<String>(
                      value: _selectedOption,
                      items:
                          _dropdownOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option, style: TextFonts.normal4),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                          // Add filtering logic here if needed
                        });
                      },
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 189,
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
                          // Handle "New" button press (e.g., add new sample)
                          print('New sample button pressed');
                        },
                        child:  Row(
                          children: [
                            Text('Print Selected', style: TextFonts.buttonText,),
                            Image.asset("assets/images/Printer.png"),
                          ],
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
              height: height * 0.6,
              width: width * 0.7,
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
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: width,
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
                      DataColumn(
                        label: Text('Sample ID', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Description', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Sample Type', style: TextFonts.normal3),
                      ),
                      DataColumn(
                        label: Text('Batch Type', style: TextFonts.normal3),
                      ),
                      DataColumn(label: Text('Date', style: TextFonts.normal3)),
                      DataColumn(label: Text('Time', style: TextFonts.normal3)),
                    ],
                    rows:
                        _samples.map((sample) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: sample['selected'],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      sample['selected'] = value ?? false;
                                    });
                                  },
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
                                  sample['description'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              DataCell(
                                Text(
                                  sample['sampleType'],
                                  style: TextFonts.normal,
                                ),
                              ),
                              DataCell(
                                Text(
                                  sample['batchType'],
                                  style: TextFonts.normal,
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }
}
