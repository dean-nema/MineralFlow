import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/models/batch_types_model.dart';

class Data {
  static int batchIDCount = 0;
  static String? currentBatchID;
  static List<BatchTypesModel> batcheTypes = [
    BatchTypesModel("Special Sample", null), 
    BatchTypesModel("Routine Sample", ["2 Hourly", "6 Hourly", "12 Hourly"]),
    BatchTypesModel("Stockpile Sample", ["Cobbles", "Peas", "Nuts", "Fines"]),
  ];
  static List<BatchSamplesModel> batches = [];

  //functions
  static BatchSamplesModel? getBatchByID() {
    for (var batch in batches) {
      if (batch.batchID == currentBatchID) {
          return batch;
      }
    }
    return null;
  }

  static int getBatchCount() {
    batchIDCount++;
    return batchIDCount;
  }
}
