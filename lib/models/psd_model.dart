import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/sample_model.dart';

class PsdModel {
  String taskName = "Particle Size Distribution";
  SampleModel sample;
  String runID = '';
  DateTime date;
  String status;
  String assignedPersonal;
  Map<double, double> data = {
    75: 0,
    50: 0,
    37.5: 0,
    25: 0,
    19: 0,
    12.5: 0,
    9.5: 0,
    4.75: 0,
    2.36: 0,
    1.18: 0,
    0.6: 0,
    0.3: 0,
    0.15: 0,
    0.075: 0,
  };
  PsdModel({
    required this.status,
    required this.sample,
    required this.date,
    required this.assignedPersonal,
    Map<double, double>? data,
  }) {
    runID = "PSD${(Data.runCount++).toString()}";
  }
  String getAge() {
    Duration difference = DateTime.now().difference(date);

    int hours = difference.inHours;
    int days = difference.inDays;

    return hours < 25 ? "$hours Hours" : "$days Days";
  }
}
