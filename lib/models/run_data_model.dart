import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/sample_model.dart';

class RunDataModel {
  SampleModel sample;
  List<String?>? furnace = [];
  List<double?>? dishWeight;
  List<double?>? sampleWeight;
  List<double?>? ashContent;
  List<double?>? dishPlusAshWeight;
  RunDataModel({
    required this.sample,
    required this.dishWeight,
    required this.sampleWeight,
    required this.ashContent,
    this.dishPlusAshWeight,
    required this.furnace,
  });

  List<double>? getDishAndSample() {
    double first = dishWeight![0]! + sampleWeight![0]!;
    double second = dishWeight![1]! + sampleWeight![1]!;
    return [first, second];
  }

  bool getResult(String task) {
    // --- Safety checks first ---
    if (ashContent == null ||
        ashContent!.length < 2 ||
        ashContent![0] == null ||
        ashContent![1] == null) {
      return false;
    }
    final double? crv = Data.crvOptions[task];
    if (crv == null) {
      print("Warning: No CRV found for task '$task'.");
      print("Ash: ${ashContent![0]} and ${ashContent![1]}");
      return false;
    }

    // --- The Core Logic ---
    // This single line solves the floating-point problem!
    final double difference = (ashContent![0]! - ashContent![1]!).abs();
    print(crv);
    print("Ash: ${ashContent![0]} and ${ashContent![1]}");
    return difference <= crv;
  }

  // bool getResult(String task) {
  //   double crv = Data.crvOptions[task]!;
  //   bool result = false;
  //   if (ashContent![0]! > ashContent![1]!) {
  //     double temp = ashContent![0]! - ashContent![1]!;
  //     print("Temp = $temp, CRV = $crv");
  //     if (temp > crv) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } else if (ashContent![1]! > ashContent![0]!) {
  //     double temp = ashContent![1]! - ashContent![0]!;
  //     print("Temp = $temp, CRV = $crv");
  //     if (temp > crv) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true; //if they are equal there is no reason
  //   }
  // }
}
