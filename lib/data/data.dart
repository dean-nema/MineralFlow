import 'dart:math';

import 'package:mineralflow/data/sample_row.dart';
import 'package:mineralflow/models/batch_model.dart';
import 'package:mineralflow/models/batch_samples_model.dart';
import 'package:mineralflow/models/batch_types_model.dart';
import 'package:mineralflow/models/recepients_model.dart';
import 'package:mineralflow/models/sample_model.dart';
import 'package:mineralflow/models/sticker_model.dart';
import 'package:mineralflow/view/components/RequestForm/DataModel/recepient.dart';
import 'package:mineralflow/view/pages/batch_details.dart';

class Data {
  //current
  static List<Map<String, dynamic>> samplesData = [];
  static String? type = "";
  static int count = 3284;
  static int sampleCount = 31291;
  static DateTime date = DateTime.now();
  static List<BatchModel> batchList = [];
  static List<String> analyticsTasks = [];
  static List<Recipient> currentRecipients = [];
  static int batchOrderCount = 2000;
  //previous
  static int batchIDCount = 0;
  static int sampleIDCount = 0;
  static String? currentBatchID;
  static BatchTypesModel? selectedBatchType;
  static List<BatchTypesModel> batcheTypes = [
    BatchTypesModel("Special Sample", []),
    BatchTypesModel("Routine Sample", ["2 Hourly", "6 Hourly", "12 Hourly"]),
    BatchTypesModel("Stockpile Sample", ["Cobbles", "Peas", "Nuts", "Fines"]),
  ];
  static List<BatchSamplesModel> batches = [];

  //functions
  //---current
  static List<TaskStatus> getBatchStats(BatchModel batch) {
    List<TaskStatus> tasks = [];
    int psdCount = 0;
    for (var element in batch.tasks) {
      print("Reached");
      tasks.add(
        TaskStatus(
          name: element,
          status: "Pending",
          numberOfSamples: batch.samples.length,
        ),
      );
    }
    tasks.add(
      TaskStatus(
        name: "Pulverization",
        status: "Pending",
        numberOfSamples: batch.samples.length,
      ),
    );
    tasks.add(
      TaskStatus(
        name: "Crushing",
        status: "Pending",
        numberOfSamples: batch.samples.length,
      ),
    );
    for (var sample in batch.samples) {
      for (var entry in sample.taskUpdate.entries) {
        if (sample.psd && entry.value == "Particle Size Distribution") {
          psdCount++;
          break;
        }
      }
    }
    TaskStatus psdTask = TaskStatus(
      name: "Particle Size Distribution",
      status: "Pending",
      numberOfSamples: psdCount,
    );
    tasks.add(psdTask);

    return tasks;
  }

  static List<SampleModel> generateSamples(int amount) {
    List<SampleModel> samples = [];
    for (var i = 1; i <= amount; i++) {
      int sampleCode = sampleCount + i;
      samples.add(SampleModel(sampleCode: sampleCode));
    }
    return samples;
  }

  static List<RecepientsModel> convertRecepients() {
    List<RecepientsModel> models = [];
    for (var recepient in currentRecipients) {
      List<String> reports =
          recepient.selectedOptions.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList();
      RecepientsModel model = RecepientsModel(
        recepient.nameController.text,
        recepient.emailController.text,
        reports,
      );
      models.add(model);
    }
    return models;
  }

  static void manipulateTasks(
    int index,
    List<bool> isChecked,
    List<String> options,
    bool value,
  ) {
    String selectedTask = options[index];
    if (value) {
      for (var task in analyticsTasks) {
        task == selectedTask ? analyticsTasks.remove(task) : null;
      }
    } else {
      analyticsTasks.add(selectedTask);
    }
  }

  static int randomNumGenerator(int size) {
    Random random = Random();
    String num = List.generate(size, (_) => random.nextInt(9)).join();
    return int.parse(num);
  }

  ///----old functions
  static String generateRandomBarcode() {
    Random random = Random();
    return List.generate(12, (_) => random.nextInt(10)).join();
  }

  static void cleanUp() {
    for (var element in batches) {
      if (!element.isComplete) {
        batches.remove(element);
      }
    }
  }

  static List<Map<String, dynamic>> getRegisteredSamples() {
    List<Map<String, dynamic>> data = [];

    for (var element in batches) {
      Map<String, dynamic> map = {};
      if (element.samplesDescription != null && element.isComplete) {
        for (var sample in element.samplesDescription!) {
          map = {
            'selected': sample.isSelected,
            'batchId': element.batchID,
            'sampleId': sample.sampleID,
            'plantLocation':
                "${element.plant!.plantName} ${element.plant!.sampleLocation}",
            'batchCategory': element.category!.categoryName,
            'mass': sample.mass.toString(),
            'sampleType': sample.sampleType,
            'sampleCategory': element.type!.batchOption,
            'batchType': element.type!.batchName,
            'description': sample.sampleDescription,
            'date': sample.sampleDate,
            'time': sample.sampleTime,
          };
          data.add(map);
        }
      }
    }
    return data;
  }

  static bool hasStickers() {
    bool flag = false;
    if (batches.isEmpty) {
      return false;
    } else {
      for (var element in batches) {
        for (var sample in element.samplesDescription!) {
          if (sample.isSelected) {
            return true;
          }
        }
      }
    }

    return flag;
  }

  static List<Map<String, dynamic>> getRegisteredSamplesCHPP() {
    List<Map<String, dynamic>> data = [];

    for (var element in batches) {
      Map<String, dynamic> map = {};
      if (element.samplesDescription != null &&
          element.isComplete &&
          element.plant?.plantName == "CHPP") {
        for (var sample in element.samplesDescription!) {
          map = {
            'selected': sample.isSelected,
            'batchId': element.batchID,
            'sampleId': sample.sampleID,
            'plantLocation':
                "${element.plant!.plantName} ${element.plant!.sampleLocation}",
            'batchCategory': element.category!.categoryName,
            'mass': sample.mass.toString(),
            'sampleType': sample.sampleType,
            'sampleCategory': element.type!.batchOption,
            'batchType': element.type!.batchName,
            'description': sample.sampleDescription,
            'date': sample.sampleDate,
            'time': sample.sampleTime,
          };
          data.add(map);
        }
      }
    }

    return data;
  }

  static List<Map<String, dynamic>> getRegisteredSamplesCWP() {
    List<Map<String, dynamic>> data = [];

    for (var element in batches) {
      Map<String, dynamic> map = {};
      if (element.samplesDescription != null &&
          element.isComplete &&
          element.plant?.plantName == "CWP") {
        for (var sample in element.samplesDescription!) {
          map = {
            'selected': sample.isSelected,
            'batchId': element.batchID,
            'sampleId': sample.sampleID,
            'plantLocation':
                "${element.plant!.plantName} ${element.plant!.sampleLocation}",
            'batchCategory': element.category!.categoryName,
            'mass': sample.mass.toString(),
            'sampleType': sample.sampleType,
            'sampleCategory': element.type!.batchOption,
            'batchType': element.type!.batchName,
            'description': sample.sampleDescription,
            'date': sample.sampleDate,
            'time': sample.sampleTime,
          };
          data.add(map);
        }
      }
    }

    return data;
  }

  static List<StickerModel> getStickers() {
    List<StickerModel> stickers = [];
    for (var element in batches) {
      for (var sample in element.samplesDescription!) {
        if (sample.isSelected) {
          StickerModel sticker = StickerModel(
            sampleDescription2: sample.sampleType,
            barcode: sample.barcode,
            date: sample.sampleDate,
            plant: element.plant!.plantName,
            type: element.type!.batchName,
            category: element.type!.batchOption,
            mass: sample.mass.toString(),
            sampleDescription: sample.sampleDescription,
            location: element.plant!.sampleLocation,
            id: sample.sampleID,
          );
          stickers.add(sticker);
        }
      }
    }

    return stickers;
  }

  static BatchSamplesModel? getBatchByID() {
    for (var batch in batches) {
      if (batch.batchID == currentBatchID) {
        return batch;
      }
    }
    return null;
  }

  static int getSampleCount() {
    sampleIDCount++;
    return sampleIDCount;
  }

  static int getBatchCountNoIncrement() {
    return batchIDCount;
  }

  static int getBatchCount() {
    batchIDCount++;
    return batchIDCount;
  }
}
