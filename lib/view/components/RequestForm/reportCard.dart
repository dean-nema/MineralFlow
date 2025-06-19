// This is the reusable component for a single recipient.
import 'package:flutter/material.dart';
import 'package:mineralflow/view/components/RequestForm/DataModel/recepient.dart';

class RecipientCard extends StatelessWidget {
  final Recipient recipient;
  final List<String> reportOptions;
  final VoidCallback onDelete;
  final Function(String, bool) onOptionChanged;

  const RecipientCard({
    super.key,
    required this.recipient,
    required this.reportOptions,
    required this.onDelete,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Using a Stack to easily place the delete button in the top-right corner.
    return Stack(
      clipBehavior: Clip.none, // Allows the button to be slightly outside
      children: [
        // The main blueGrey container
        Container(
          margin: const EdgeInsets.only(bottom: 24.0), // Space below each card
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for Name and Email fields
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Recipient Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: recipient.nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter recipient name',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Recipient Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: recipient.emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter recipient email',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Checkbox options for this specific recipient
              Wrap(
                spacing: 10.0,
                runSpacing: 0.0,
                children: reportOptions.map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: recipient.selectedOptions[option],
                        onChanged: (bool? value) {
                          onOptionChanged(option, value!);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          onOptionChanged(option, !recipient.selectedOptions[option]!);
                        },
                        child: Text(option),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // The "X" delete button
        Positioned(
          top: -10,
          right: -10,
          child: InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(1, 1))]
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
