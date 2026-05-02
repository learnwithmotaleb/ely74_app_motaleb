class PackageModel {
  String? sId;
  String? type;
  int? iV;
  String? createdAt;
  List<String>? features;
  String? name;
  num? price;
  String? updatedAt;

  PackageModel({
    this.sId,
    this.type,
    this.iV,
    this.createdAt,
    this.features,
    this.name,
    this.price,
    this.updatedAt,
  });

  PackageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    type = json['type']?.toString();
    iV = json['__v'] is int ? json['__v'] : int.tryParse(json['__v']?.toString() ?? '');
    createdAt = json['createdAt']?.toString();
    name = json['name']?.toString();
    updatedAt = json['updatedAt']?.toString();
    price = json['price'] is num
        ? json['price']
        : num.tryParse(json['price']?.toString() ?? '0');

    if (json['features'] is List) {
      features = List<String>.from(
        (json['features'] as List).map((e) => e.toString()),
      );
    } else {
      features = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'type': type,
      '__v': iV,
      'createdAt': createdAt,
      'features': features,
      'name': name,
      'price': price,
      'updatedAt': updatedAt,
    };
  }
}
class MyPackageModel {
  final String? type;
  final String? price;
  final String? expiresIn;
  final String? subscriptionId;
  final String? isActive;

  MyPackageModel( {
    this.type,
    this.price,
    this.expiresIn,
    this.subscriptionId,this.isActive,
  });
}

