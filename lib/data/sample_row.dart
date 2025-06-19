import 'package:flutter/material.dart';

// The model is enhanced with a flag to track its origin.
class SampleRow {
  final String id;
  // We no longer store seqNumber here; it's a display-only value based on the list index.
  
  // A flag to determine if the row's key data is editable.
  final bool isFromInitialData;

  // Controllers for all text fields
  final TextEditingController sampleCodeController;
  final TextEditingController sampleDescriptionController;
  final TextEditingController sampleLocationController;
  final TextEditingController receivingWeightController;

  // State for other input types
  String? sampleType;
  bool psd;
  DateTime? receivingDateTime;

  SampleRow({
    required this.id,
    required this.isFromInitialData,
    required this.sampleCodeController,
    required this.sampleDescriptionController,
    required this.sampleLocationController,
    required this.receivingWeightController,
    this.sampleType,
    this.psd = false,
    this.receivingDateTime,
  });
}
