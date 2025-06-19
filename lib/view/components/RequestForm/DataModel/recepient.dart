// A model to hold all the data for one recipient card.
import 'package:flutter/material.dart';

class Recipient {
  final String id; // Unique ID for each recipient
  final TextEditingController nameController;
  final TextEditingController emailController;
  final Map<String, bool> selectedOptions;

  Recipient({
    required this.id,
    required this.nameController,
    required this.emailController,
    required this.selectedOptions,
  });
}
