import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/models/batch_selected_type_model.dart';
import 'package:mineralflow/models/plant_details_model.dart';
import 'package:mineralflow/models/sample_description_model.dart';

class BatchSamplesModel {
  bool isComplete = false;
  final String _batchID;
  BatchCategory? _category;
  BatchSelectedTypeModel? _type;
  PlantDetailsModel? _plant;
  List<SampleDescriptionModel>? _samplesDescription;

  BatchSamplesModel([
    this._category,
    this._type,
    this._plant,
    this._samplesDescription,
  ]) : _batchID = "B${Data.getBatchCount()}";

  String get batchID => _batchID;
  BatchCategory? get category => _category;

  set category(BatchCategory? value) {
    _category = value;
  }

  BatchSelectedTypeModel? get type => _type;

  set type(BatchSelectedTypeModel? value) {
    _type = value;
  }

  PlantDetailsModel? get plant => _plant;

  set plant(PlantDetailsModel? value) {
    _plant = value;
  }

  List<SampleDescriptionModel>? get samplesDescription => _samplesDescription;

  void addSample(SampleDescriptionModel sample) {
    if (_samplesDescription != null) {
      _samplesDescription!.add(sample);
    } else {
      _samplesDescription = [sample];
    }
  }
}
