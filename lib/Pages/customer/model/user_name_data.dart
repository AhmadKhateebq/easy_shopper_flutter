class AppUserUsername {
  final int id;
  final String username;
  AppUserUsername({
    required this.id,
    required this.username,
  });
  factory AppUserUsername.fromJson(Map<String, dynamic> json) {
    return AppUserUsername(
      id: json['id'],
      username: json['username'],
    );
  }
}
