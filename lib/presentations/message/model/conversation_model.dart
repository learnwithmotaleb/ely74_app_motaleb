class ConversationModel {
  String? sId;
  List<Users>? users;
  bool? isBlocked;
  String? blockedBy;

  ConversationModel({this.sId, this.users, this.isBlocked, this.blockedBy});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    isBlocked = json['isBlocked'];
    blockedBy = json['blockedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['isBlocked'] = this.isBlocked;
    data['blockedBy'] = this.blockedBy;
    return data;
  }
}



class Users {
  String? sId;
  String? name;
  String? email;
  String? img;

  Users({this.sId, this.name, this.email, this.img});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['img'] = img;
    return data;
  }
}
