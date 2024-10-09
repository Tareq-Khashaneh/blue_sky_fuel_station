class UserModel {
  final int id;
  late final String name;
  final String pin;
  final String? perm;
  final int? sessionNumber;
  final int? sessionStatus;

  UserModel(
      {required this.id,
      required this.name,
      required this.pin,
      required this.perm,
      required this.sessionNumber,
      required this.sessionStatus});

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
      id: data['id'],
      name: data['username'],
      pin: data['pin'],
      perm: data['perm'],
      sessionNumber: data['session_number'],
      sessionStatus: data['session_status']);
}
