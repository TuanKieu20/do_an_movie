class UserModel {
  String? avatar;
  String? email;
  String? id;
  bool? isVip;
  bool? isAdmin;

  UserModel({this.avatar, this.email, this.id, this.isAdmin, this.isVip});

  UserModel.fromJson(Map<String, dynamic> json, {required String? idDoc}) {
    avatar = json['avatar'];
    email = json['email'];
    id = idDoc;
    isAdmin = json['isAdmin'] ?? false;
    isVip = json['isVip'] ?? false;
  }
}
