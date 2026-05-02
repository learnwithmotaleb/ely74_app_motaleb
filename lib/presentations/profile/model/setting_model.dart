class SettingsModel {
  String? name;
  String? desc;

  SettingsModel({this.name, this.desc});

  SettingsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['desc'] = desc;
    return data;
  }
}