
import '../../core/constants/typedef.dart';
import '../models/auth_model.dart';
import '../models/session_details_model.dart';
import '../repositories/auth_repo.dart';

class AuthProvider {
  final AuthRepo _authRepo;

  AuthProvider({required AuthRepo authRepo}) : _authRepo = authRepo;
  Future<AuthModel?> getAuthData(parameters params) async {
    try {
      Map<String, dynamic>? data = await _authRepo.getAuthData(params);
      if (data != null) {
        return AuthModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("error in AuthProvider  $e");
      return null;
    }
  }

  Future<SessionDetailsModel?> getLogoutData(parameters params) async {
    try {
      Map<String, dynamic>? data = await _authRepo.getLogoutData(params);
      if (data != null) {
        return SessionDetailsModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("error in logout provider 1 $e");
      return null;
    }
  }
}
