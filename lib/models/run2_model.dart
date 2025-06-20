import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/sample_model.dart';

class Run2Model {
  String taskName;
  String runID = "";
  String status;
  List<SampleModel> samples;
  DateTime date;
  String assignedPersonal;
  Run2Model({
    required this.taskName,
    required this.status,
    required this.samples,
    required this.date,
    required this.assignedPersonal,
  }) {
    runID = "${Data.getInitials(taskName)}" + (Data.runCount + 1).toString();
  }
  String getAge() {
    Duration difference = DateTime.now().difference(date);

    int hours = difference.inHours;
    int days = difference.inDays;
    return hours < 25 ? "$hours Hours" : "$days Days";
  }
}
