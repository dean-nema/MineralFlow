import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';

class SampleInfo extends StatefulWidget {
  PlatformFile? document;
  TextEditingController amount;
  TextEditingController submitter;
  TextEditingController projectName;
  TextEditingController batchLocation;
  String? classification;
  SampleInfo({
    super.key,
    required this.document,
    required this.projectName,
    required this.submitter,
    required this.batchLocation,
    required this.amount,
    required this.classification,
  });

  @override
  State<SampleInfo> createState() => _SampleInfoState();
}

class _SampleInfoState extends State<SampleInfo> {
  //variables
  // String? _selectedClassification;
  DateTime? _selectedDateTime;
  final TextEditingController _dateController = TextEditingController();
  PlatformFile? _selectedFile;
  final List<String> _classifications = [
    'Process Plant',
    'Channel Sample',
    'Special Sample',
  ];

  //functions
  // 3. Clean up the controller when the widget is disposed
  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // 4. The function to show the date and time pickers
  Future<void> _selectDateTime(BuildContext context) async {
    // Show the date picker first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // If the user didn't cancel the date picker
    if (pickedDate != null) {
      // Then, show the time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now(),
        ),
      );

      // If the user didn't cancel the time picker
      if (pickedTime != null) {
        // Combine the picked date and time into one DateTime object
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          Data.date = _selectedDateTime!;
          // Format the DateTime and update the text field
          _dateController.text = DateFormat(
            'dd/MM/yyyy - hh:mm a',
          ).format(_selectedDateTime!);
        });
      }
    }
  }

  // 2. List of options for the dropdown
  // 3. Logic to open the file picker and handle the result
  void _pickFile() async {
    // Opens the file picker dialog
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // Restrict to only the allowed file types
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    // If the user picked a file (result is not null)
    if (result != null) {
      // Update the state to hold the file's information
      setState(() {
        _selectedFile = result.files.first;
        widget.document = _selectedFile;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width < 1866 ? true : false;

    return Container(
      width: width * 0.7,
      // The fixed height was removed to allow the card to size itself based on its content.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
              child: Text(
                // 2. "Sample Information" text is bold
                "Sample Information",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          // This Padding provides the consistent left indentation for the form fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Submitter Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: TextField(
                        controller: widget.submitter,
                        decoration: InputDecoration(
                          // 5. A grey label that starts at the left
                          hintText: 'Enter your full Name',
                          // 6. Label style with font size 18
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                          // 4. blueGrey background color
                          fillColor: Colors.blueGrey[50],
                          filled: true,
                          // 7. Round corners for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // Hides the border line to show only the filled color
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sample Receipt Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: GestureDetector(
                        onTap: () => _selectDateTime(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              // 5. A grey label that starts at the left
                              hintText: "Select Date & Time",
                              // 6. Label style with font size 18
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                              // 4. blueGrey background color
                              fillColor: Colors.blueGrey[50],
                              filled: true,
                              // 7. Round corners for the text field
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                // Hides the border line to show only the filled color
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sample Classification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: DropdownButtonFormField(
                        // The value of the currently selected item.
                        value: widget.classification,
                        // Hint text that appears when no item is selected.
                        hint: const Text(
                          'Please choose a classification',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Decoration to style the dropdown like your TextField.
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                          fillColor: Colors.blueGrey[50],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, // Adjusted for dropdown arrow
                            horizontal: 20.0,
                          ),
                        ),
                        items:
                            _classifications.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.classification = newValue;
                            Data.type = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Batch Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: TextField(
                        controller: widget.batchLocation,
                        decoration: InputDecoration(
                          // 5. A grey label that starts at the left
                          hintText: 'Enter Batch Location',
                          // 6. Label style with font size 18
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                          // 4. blueGrey background color
                          fillColor: Colors.blueGrey[50],
                          filled: true,
                          // 7. Round corners for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // Hides the border line to show only the filled color
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Project",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: TextField(
                        controller: widget.projectName,
                        decoration: InputDecoration(
                          // 5. A grey label that starts at the left
                          hintText: 'Enter Project Name',
                          // 6. Label style with font size 18
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                          // 4. blueGrey background color
                          fillColor: Colors.blueGrey[50],
                          filled: true,
                          // 7. Round corners for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // Hides the border line to show only the filled color
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // 3. This aligns "Submitter Name" and the TextField to the left
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Number of Samples",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 400,
                      child: TextField(
                        controller: widget.amount,
                        decoration: InputDecoration(
                          // 5. A grey label that starts at the left
                          hintText: "Enter Number of Samples",
                          // 6. Label style with font size 18
                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                          // 4. blueGrey background color
                          fillColor: Colors.blueGrey[50],
                          filled: true,
                          // 7. Round corners for the text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            // Hides the border line to show only the filled color
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Text(
            "Sample  Request Document",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      _selectedFile == null
                          ? "No File Selected"
                          : _selectedFile!.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Icon(Icons.upload_file, color: Colors.blueGrey[50]),
                  ),
                ),
              ],
            ),
          ),
          Text("Accepted formats: PDF, DOC, DOCX"),
        ],
      ),
    );
  }
}
