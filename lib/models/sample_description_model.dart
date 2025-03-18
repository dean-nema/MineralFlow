import 'package:intl/intl.dart';
import 'package:mineralflow/data/data.dart';

class SampleDescriptionModel {
  String _sampleType = "";
    bool isSelected = false;
  String barcode = '';
  String _sampleDescription = "";
  String sampleID;
  double _mass = 0;
  String? _sampleDetails;
  String sampleDate;
  String sampleTime;

  SampleDescriptionModel(this._sampleType, this._sampleDescription, 
  this._mass, this._sampleDetails): sampleID = "B${Data.getBatchCountNoIncrement()}S${Data.getSampleCount()}", sampleDate = DateFormat('yyyy/MM/dd').format(DateTime.now()), sampleTime =  DateFormat('HH:mm').format(DateTime.now()), barcode = Data.generateRandomBarcode();

  String get sampleDescription => _sampleDescription;

  set sampleDescription(String description) {
    _sampleDescription = description;
  }
  String get sampleType => _sampleType;

  set sampleType(String sampleType1) {
    _sampleType = sampleType1;
  }
  
  double get mass => _mass;

  set mass(double value) {
    if (value >= 0) {
      _mass = value;
    } else {
      // throw ArgumentError("Mass cannot be negative");
      print("Mass cannot be negative");
    }
  }

  String? get sampleDetails => _sampleDetails;

  set sampleDetails(String? details) {
    _sampleDetails = details;
  }
}
