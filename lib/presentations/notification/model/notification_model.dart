class NotificationModel {
  String? sId;
  User? user;
  String? title;
  String? message;
  bool? readByAdmin;
  bool? readByUser;
  int? iV;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.sId,
        this.user,
        this.title,
        this.message,
        this.readByAdmin,
        this.readByUser,
        this.iV,
        this.createdAt,
        this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    message = json['message'];
    readByAdmin = json['read_by_admin'];
    readByUser = json['read_by_user'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['title'] = title;
    data['message'] = message;
    data['read_by_admin'] = readByAdmin;
    data['read_by_user'] = readByUser;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? img;

  User({this.sId, this.name, this.img});

  User.fromJson(Map<String, dynamic> json) {
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
