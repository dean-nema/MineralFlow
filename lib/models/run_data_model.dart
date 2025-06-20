import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/sample_model.dart';

class RunDataModel {
  SampleModel sample;
  List<String> furnace = [];
  List<double> dishWeight;
  List<double> sampleWeight;
  List<double> ashContent;
  RunDataModel({
    required this.sample,
    required this.dishWeight,
    required this.sampleWeight,
    required this.ashContent,
    required this.furnace,
  });

  List<double> getDishAndSample() {
    double first = dishWeight[0] + sampleWeight[0];
    double second = dishWeight[1] + sampleWeight[1];
    return [first, second];
  }

  bool getResult(String task) {
    double crv = Data.crvOptions[task]!;
    bool result = false;
    if (ashContent[0] > ashContent[1]) {
      double temp = ashContent[0] - ashContent[1];
      if (temp > crv) {
        return false;
      } else {
        return true;
      }
    } else if (ashContent[1] > ashContent[0]) {
      double temp = ashContent[1] - ashContent[0];
      if (temp > crv) {
        return false;
      } else {
        return true;
      }
    } else {
      return true; //if they are equal there is no reason
    }
  }
}
