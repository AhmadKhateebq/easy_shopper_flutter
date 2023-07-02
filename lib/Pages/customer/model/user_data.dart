import 'dart:convert';

class AppUser {
  final int? id;
  final String username;
  final String fname;
  final String lname;
  final String email;
  final String? facebookId;
  final String? googleId;
  final String? pictureUrl;

  AppUser({
    this.id,
    required this.username,
    required this.fname,
    required this.lname,
    required this.email,
    this.facebookId,
    this.googleId,
    this.pictureUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      facebookId: json['facebook_id'],
      googleId: json['google_id'],
      pictureUrl: json['picture_url'],
    );
  }
  String toJson() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'username': username,
      'fname': fname,
      'lname': lname,
      'email': email,
      'facebook_id': facebookId,
      'google_id': googleId,
      'picture_url': pictureUrl,
    });
  }
}
