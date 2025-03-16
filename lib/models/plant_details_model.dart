class PlantDetailsModel {
  String _plantName = "";
  String _sampleLocation = "";
  String? _plantFullName;

  PlantDetailsModel(this._plantName, this._sampleLocation, this._plantFullName);

  String get plantName => _plantName;

  set plantName(String name) {
    _plantName = name;
  }

  String get sampleLocation => _sampleLocation;

  set sampleLocation(String location) {
    _sampleLocation = location;
  }

  String? get plantFullName => _plantFullName;

  set plantFullName(String? fullName) {
    _plantFullName = fullName;
  }
}
