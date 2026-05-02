class ChattingUserModel {
  String? sId;
  List<ConversationUserModel>? users;
  bool? isBlocked;
  String? blockedBy;

  ChattingUserModel({this.sId, this.users, this.isBlocked, this.blockedBy});

  ChattingUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['users'] != null) {
      users = <ConversationUserModel>[];
      json['users'].forEach((v) {
        users!.add(new ConversationUserModel.fromJson(v));
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


class MessageModel {
  String? sId;
  String? conversationId;
  String? message;
  String? img;
  String? voiceMessage;
  String? sender;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageModel(
      {this.sId,
        this.conversationId,
        this.message,
        this.img,
        this.voiceMessage,
        this.sender,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversation_id'];
    message = json['message'];
    img = json['img'];
    voiceMessage = json['voice_message'];
    sender = json['sender'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversation_id'] = conversationId;
    data['message'] = message;
    data['img'] = img;
    data['voice_message'] = voiceMessage;
    data['sender'] = sender;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ConversationUserModel {
  String? sId;
  String? name;
  String? email;
  String? img;

  ConversationUserModel({this.sId, this.name, this.email, this.img});

  ConversationUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['img'] = this.img;
    return data;
  }
}

