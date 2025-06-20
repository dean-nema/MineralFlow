import 'package:file_picker/file_picker.dart';
import 'package:mineralflow/models/recepients_model.dart';
import 'package:mineralflow/models/sample_model.dart';

class BatchModel {
  String submitter;
  String client;
  PlatformFile? document;
  List<String> tasks;
  List<RecepientsModel> recepients;
  String project;
  double? priority;
  String? batchLocation;
  String? assignedPersonal;
  String? status;
  String batchOrder;
  DateTime receivingDate;
  List<SampleModel> samples;

  BatchModel({
    required this.submitter,
    required this.client,
    this.document,
    required this.tasks,
    required this.recepients,
    required this.project,
    this.status,
    this.priority,
    this.batchLocation,
    this.assignedPersonal,
    required this.batchOrder,
    DateTime? receivingDate,
    required this.samples,
  }) : receivingDate = receivingDate ?? DateTime.now();

  String getClientCode() {
    String code = "";
    switch (client) {
      case "Channel Sample":
        code = "MCM MARKET";
        break;
      case "Process Plant":
        code = "MCM PLANT";
        break;
      case "Special Sample":
        code = "MCM GEOLOGY";
        break;
      default:
    }

    return code;
  }

  String getAge() {
    Duration difference = DateTime.now().difference(receivingDate);

    int hours = difference.inHours;
    int days = difference.inDays;

    return "$hours Hours";
  }

  int numOfSamples() {
    return samples.length;
  }
}

enum Status { onHold, active, finalized, cancelled }

class Clients {
  static String plant = "MCM PLANT";
  static String geo = "MCM GEOLOGY";
  static String market = "MCM MARKET";
}
