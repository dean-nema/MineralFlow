import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/run_data_model.dart';
import 'package:mineralflow/models/sample_model.dart';

class RunModel {
  String taskName;
  String runID = "";
  String status;
  List<SampleModel> samples;
  DateTime date;
  String assignedPersonal;
  List<RunDataModel> data = [];
  RunModel({
    required this.taskName,
    required this.status,
    required this.samples,
    required this.date,
    required this.assignedPersonal,
    // The data list is optional. If not provided, it will default to an empty list.
    List<RunDataModel>? data,
  }) : data = data ?? [] {
    runID = "${Data.getInitials(taskName)}" + (Data.runCount + 1).toString();
  }
}
