import 'package:mineralflow/data/data.dart';
import 'package:mineralflow/models/batch_category_model.dart';
import 'package:mineralflow/models/batch_types_model.dart';
import 'package:mineralflow/models/plant_details_model.dart';
import 'package:mineralflow/models/sample_description_model.dart';
import 'package:mineralflow/view/pages/batch_type.dart';

class BatchSamplesModel {
  final String _batchID; 
  BatchCategory? _category;
  BatchTypesModel? _type;
  PlantDetailsModel? _plant;
  SampleDescriptionModel? _samplesDescription;

  BatchSamplesModel([this._category, this._type, this._plant, this._samplesDescription])
  :  _batchID = "B${Data.getBatchCount()}";       
  
  String get batchID => _batchID;
  BatchCategory? get category => _category;

  set category(BatchCategory? value) {
    _category = value;
  }

  BatchTypesModel? get type => _type;

  set type(BatchTypesModel? value) {
    _type = value;
  }

  PlantDetailsModel? get plant => _plant;

  set plant(PlantDetailsModel? value) {
    _plant = value;
  }

  SampleDescriptionModel? get samplesDescription => _samplesDescription;

  set samplesDescription(SampleDescriptionModel? value) {
    _samplesDescription = value;
  }
}
