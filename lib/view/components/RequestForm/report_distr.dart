// Your main widget, now Stateful to manage the list of recipients.
import 'package:flutter/material.dart';
import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/view/components/RequestForm/DataModel/recepient.dart';
import 'package:mineralflow/view/components/RequestForm/reportCard.dart';

class ReportDistr extends StatefulWidget {
  const ReportDistr({super.key});

  @override
  State<ReportDistr> createState() => _ReportDistrState();
}

class _ReportDistrState extends State<ReportDistr> {
  // The list of available checkbox options (constant).
  final List<String> _reportOptions = const [
    'PDF Certificate',
    'Result CSV',
    'QC Performance',
    'TAT Performance',
  ];

  // The state: a list that holds all our recipient data.
  // List<Recipient> _recipients = [];

  @override
  void initState() {
    super.initState();
    // Start with one recipient when the widget is first created.
    for (var recipient in Data.currentRecipients) {
      recipient.nameController.clear();
      recipient.emailController.clear();
    }
    _addRecipient();
  }

  // Clean up controllers when the widget is removed.
  @override
  void dispose() {
    for (var recipient in Data.currentRecipients) {
      recipient.nameController.clear();
      recipient.emailController.clear();
    }
    super.dispose();
  }

  void _addRecipient() {
    setState(() {
      // Create a new recipient with a unique ID and fresh data.
      final newRecipient = Recipient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nameController: TextEditingController(),
        emailController: TextEditingController(),
        selectedOptions: {for (var option in _reportOptions) option: false},
      );
      Data.currentRecipients.add(newRecipient);
      // _recipients.add(newRecipient);
    });
  }

  void _deleteRecipient(String id) {
    setState(() {
      // Find the recipient to delete.
      final recipientToRemove = Data.currentRecipients.firstWhere(
        (r) => r.id == id,
      );
      // IMPORTANT: Dispose controllers to prevent memory leaks!
      recipientToRemove.nameController.dispose();
      recipientToRemove.emailController.dispose();
      // Remove from the list.
      Data.currentRecipients.removeWhere((recipient) => recipient.id == id);
      Data.currentRecipients.removeWhere((recipient) => recipient.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Header (remains the same)
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
                "Report Distribution List",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          // Main content area with padding
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamically build a list of RecipientCard widgets
                ...Data.currentRecipients.map((recipient) {
                  return RecipientCard(
                    // Use a UniqueKey or a key based on the recipient's ID.
                    key: ValueKey(recipient.id),
                    recipient: recipient,
                    reportOptions: _reportOptions,
                    onDelete: () => _deleteRecipient(recipient.id),
                    onOptionChanged: (option, value) {
                      setState(() {
                        recipient.selectedOptions[option] = value;
                      });
                    },
                  );
                }).toList(),

                const SizedBox(height: 16),

                // The "Add" button at the bottom
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addRecipient,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Recipient"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
