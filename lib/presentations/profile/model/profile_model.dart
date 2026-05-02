class ProfileModel {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? img;
  String? role;
  bool? block;
  bool? isVerified;
  String? provider;
  String? accessToken;
  String? useType;
  bool? isIdentityVerified;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isSubscribed;

  ProfileModel(
      {this.sId,
        this.name,
        this.email,
        this.phone,
        this.img,
        this.role,
        this.block,
        this.isVerified,
        this.provider,
        this.accessToken,
        this.useType,
        this.isIdentityVerified,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isSubscribed});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    img = json['img'];
    role = json['role'];
    block = json['block'];
    isVerified = json['is_verified'];
    provider = json['provider'];
    accessToken = json['accessToken'];
    useType = json['use_type'];
    isIdentityVerified = json['is_identity_verified'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isSubscribed = json['is_subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['img'] = img;
    data['role'] = role;
    data['block'] = block;
    data['is_verified'] = isVerified;
    data['provider'] = provider;
    data['accessToken'] = accessToken;
    data['use_type'] = useType;
    data['is_identity_verified'] = isIdentityVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['is_subscribed'] = isSubscribed;
    return data;
  }
}
