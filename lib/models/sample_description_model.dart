class SampleDescriptionModel {
  String _sampleDescription = "";
  double _mass = 0;
  String? _sampleDetails;

  SampleDescriptionModel(this._sampleDescription, this._mass, this._sampleDetails);

  String get sampleDescription => _sampleDescription;

  set sampleDescription(String description) {
    _sampleDescription = description;
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
