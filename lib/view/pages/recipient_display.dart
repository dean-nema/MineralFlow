// lib/view/pages/recipients_page.dart
import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/view/Constants/texts.dart';
import 'package:mineralflow/view/components/RequestForm/DataModel/recepient.dart';
import 'package:mineralflow/view/components/RequestForm/reportCard.dart';

class RecipientsPage extends StatefulWidget {
  final BatchModel batch;
  const RecipientsPage({super.key, required this.batch});

  @override
  State<RecipientsPage> createState() => _RecipientsPageState();
}

class _RecipientsPageState extends State<RecipientsPage> {
  final List<String> _reportOptions = const [
    'PDF Certificate',
    'Result CSV',
    'QC Performance',
    'TAT Performance',
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipientsFromBatch(widget.batch);
  }

  @override
  void dispose() {
    // The only responsibility of dispose is to clean up controllers.
    for (var recipient in Data.currentRecipients) {
      recipient.nameController.clear();
      recipient.emailController.clear();
    }
    super.dispose();
  }

  // --- NEW: Validation and Save Function ---
  bool _validateAndSaveChanges() {
    // Check if any recipient has empty fields.
    for (int i = 0; i < Data.currentRecipients.length; i++) {
      final recipient = Data.currentRecipients[i];
      if (recipient.nameController.text.trim().isEmpty ||
          recipient.emailController.text.trim().isEmpty) {
        // If an empty field is found, show an error and stop.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill all name and email fields for recipient #${i + 1}.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return true; // Exit the function
      }
    }
    return false;
    // If all validations pass, save the data and pop the page.
  }

  void _loadRecipientsFromBatch(BatchModel batch) {
    Data.currentRecipients.clear();
    for (var element in batch.recepients) {
      final newRecipient = Recipient(
        id: Data.randomNumGenerator(6).toString(),
        nameController: TextEditingController(text: element.name),
        emailController: TextEditingController(text: element.email),
        selectedOptions: {
          for (var masterOption in _reportOptions)
            masterOption: element.reports.contains(masterOption),
        },
      );
      Data.currentRecipients.add(newRecipient);
    }
    if (Data.currentRecipients.isEmpty) {
      _addRecipient();
    }
  }

  void _addRecipient() {
    setState(() {
      final newRecipient = Recipient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nameController: TextEditingController(),
        emailController: TextEditingController(),
        selectedOptions: {for (var option in _reportOptions) option: false},
      );
      Data.currentRecipients.add(newRecipient);
    });
  }

  void _deleteRecipient(String id) {
    setState(() {
      final recipientToRemove = Data.currentRecipients.firstWhere(
        (r) => r.id == id,
      );
      recipientToRemove.nameController.dispose();
      recipientToRemove.emailController.dispose();
      Data.currentRecipients.removeWhere((recipient) => recipient.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text(
          "Manage Recipients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        // --- NEW: Added actions for the Save button ---
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _validateAndSaveChanges,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text("Manage Recipients", style: TextFonts.titles),
                    SizedBox(height: 50),
                    Text(
                      "Recipients for Batch:${widget.batch.batchOrder}",
                      style: TextFonts.normal,
                    ),
                  ],
                ),
              ),
            ),
            ...Data.currentRecipients.map((recipient) {
              return Center(
                child: SizedBox(
                  width: screenWidth * 0.6,
                  child: RecipientCard(
                    key: ValueKey(recipient.id),
                    recipient: recipient,
                    reportOptions: _reportOptions,
                    onDelete: () => _deleteRecipient(recipient.id),
                    onOptionChanged: (option, value) {
                      setState(() {
                        recipient.selectedOptions[option] = value;
                      });
                    },
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: screenWidth * 0.6,
                child: ElevatedButton.icon(
                  onPressed: _addRecipient,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Add Another Recipient"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
