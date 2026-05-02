class CategoryModel {
  String? sId;
  String? name;
  String? img;

  CategoryModel({this.sId, this.name, this.img});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['img'] = img;
    return data;
  }
}
class SubCategoryModel {
  String? sId;
  String? name;
  String? categoryId;
  String? categoryName;

  SubCategoryModel({this.sId, this.name, this.categoryId, this.categoryName});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    return data;
  }
}

class CityModel {
  String? sId;
  String? name;
  String? divisionName;
  String? divisionId;

  CityModel({this.sId, this.name, this.divisionName, this.divisionId});

  CityModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    divisionName = json['division_name'];
    divisionId = json['division_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['division_name'] = divisionName;
    data['division_id'] = divisionId;
    return data;
  }
}
