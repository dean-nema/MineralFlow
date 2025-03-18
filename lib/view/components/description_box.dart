import 'package:flutter/material.dart';
import 'package:mineralflow/view/Constants/colors.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/pages/sample_description.dart';

class DescriptionBox extends StatefulWidget {
  final String title;
  DescriptionBoxClass boxDetails;
   DescriptionBox({super.key, required this.title, required this.boxDetails});

  @override
  State<DescriptionBox> createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<DescriptionBox> {
    TextEditingController massController = TextEditingController();
  String _selectedValue = "Rock";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Container(
        width: 630,
        height: 300,
        decoration: BoxDecoration(
          color: Colours.btn,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(widget.title, style: TextFonts.buttonTitles,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20),
                child: Row(
                  children: [
                    Expanded(child: Text("Description", style: TextFonts.buttonTitles4)),
                    Expanded(
                      child: DropdownMenu<String>(
                        initialSelection: "Rock", // No initial selection
                        textStyle: TextFonts.normal,
                        onSelected: (String? value) {
                          setState(() {
                            _selectedValue = value!; // Update selected value
                            widget.boxDetails.description = value;
                          });
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry<String>(value: 'Rock', label: 'Rock'),
                          DropdownMenuEntry<String>(value: 'Pulp', label: 'Pulp'),
                          DropdownMenuEntry<String>(
                            value: 'Percussion',
                            label: 'Percussion',
                          ),
                          DropdownMenuEntry<String>(value: 'Other', label: 'Other'),
                        ],
                        // Customize the dropdown appearance
                        menuStyle: MenuStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ), // White background for dropdown
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: true,
                          fillColor:
                              Colors.white, // White background for the input field
                        ),
                        width: 318, // Optional: set a fixed width
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20),
                child: Row(
                  children: [
                    Expanded(child: Text("Mass (g)", style: TextFonts.buttonTitles4)),
                    Expanded(
                      child: SizedBox(
                        width: 318,
                        height: 66,
                        child: TextField(
                            onChanged: (value){
                                try {
                                    double massValue = double.parse(value); 
                            widget.boxDetails.description = _selectedValue;
                                widget.boxDetails.mass = massValue;
                                } catch (e) {
                                         print(e);                         
                                      }
                            },
                            controller: massController,
                          style: TextStyle(
                            color: Colours.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            
                            suffixIcon: IconButton(
                              onPressed: () => massController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          maxLength: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
