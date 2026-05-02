
import 'package:market_place/presentations/home/model/category_subcategory_model.dart';

class ProductModel {
  String? sId;
  String? name;
  String? price;
  String? condition;
  String? createdAt;
  bool? isFavorite;
  String? img;
  String? categoryName;

  ProductModel(
      {this.sId,
        this.name,
        this.price,
        this.condition,
        this.isFavorite,
        this.createdAt,
        this.img,
        this.categoryName});

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString()=='null'?'n/a':json['_id'].toString();
    name = json['name'].toString()=='null'?'n/a':json['name'].toString();
    price = json['price'].toString()=='null'?'n/a':json['price'].toString();
    condition = json['condition'].toString()=='null'?'n/a':json['condition'].toString();
    createdAt = json['createdAt'].toString()=='null'?'n/a':json['createdAt'].toString();
    isFavorite = json['is_favorite'];
    img = json['img'].toString()=='null'?'n/a':json['img'].toString();
    categoryName = json['category_name'].toString()=='null'?'n/a':json['category_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['condition'] = condition;
    data['createdAt'] = createdAt;
    data['is_favorite'] = isFavorite;
    data['img'] = img;
    data['category_name'] = categoryName;
    return data;
  }
}
class ProductDetailsModel {
  String? sId;
  String? name;
  String? description;
  int? price;
  List<String>? img;
  String? condition;
  bool? isFavorite;
  String? categoryName;
  String? categoryId;
  String? subCategoryName;
  CategoryModel? categories;
  SubCategoryModel? subCategories;
  CategoryModel? divisions;
  CityModel? cities;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userImg;
  String? userId;

  ProductDetailsModel(
      {this.sId,
        this.name,
        this.description,
        this.price,
        this.img,
        this.condition,
        this.isFavorite,
        this.categoryName,
        this.categoryId,
        this.subCategoryName,
        this.categories,
        this.subCategories,
        this.divisions,
        this.cities,
        this.userName,
        this.userEmail,
        this.userPhone,
        this.userImg,
        this.userId});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    img = json['img'].cast<String>();
    condition = json['condition'];
    isFavorite = json['is_favorite'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    subCategoryName = json['sub_category_name'];
    categories = json['categories'] != null
        ? CategoryModel.fromJson(json['categories'])
        : null;
    subCategories = json['sub_categories'] != null
        ? SubCategoryModel.fromJson(json['sub_categories'])
        : null;
    divisions = json['divisions'] != null
        ? CategoryModel.fromJson(json['divisions'])
        : null;
    cities =
    json['cities'] != null ? CityModel.fromJson(json['cities']) : null;
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    userImg = json['user_img'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['img'] = img;
    data['condition'] = condition;
    data['is_favorite'] = isFavorite;
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    data['sub_category_name'] = subCategoryName;
    if (categories != null) {
      data['categories'] = categories!.toJson();
    }
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.toJson();
    }
    if (divisions != null) {
      data['divisions'] = divisions!.toJson();
    }
    if (cities != null) {
      data['cities'] = cities!.toJson();
    }
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['user_img'] = userImg;
    data['user_id'] = userId;
    return data;
  }
}



