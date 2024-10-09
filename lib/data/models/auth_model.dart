
class AuthModel{
  final String? sessionId;
  final String? sessionNumber;

  AuthModel({required this.sessionId, required this.sessionNumber});
  factory AuthModel.fromJson(var json)
  => AuthModel(sessionId: json['session_id'], sessionNumber: json['session_number']);
}