class RecepientsModel {
  String name = "";
  String email = "";
  List<String> reports = [];

  // Constructor
  RecepientsModel(this.name, this.email, [List<String>? reports])
    : reports = reports ?? [];
}
