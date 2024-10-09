import '../../core/constants/typedef.dart';
import '../models/data_model.dart';
import '../repositories/init_repo.dart';

class InitProvider {
  final InitRepository _initRepository;

  InitProvider({required InitRepository initRepository})
      : _initRepository = initRepository;
  Future<DataModel?> getMainData(parameters params) async {
    try {
      Map<String, dynamic>? data = await _initRepository.getMainData(params);
      if (data != null) {
        return DataModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("error in InitProvider  $e");
      return null;
    }
  }
}
