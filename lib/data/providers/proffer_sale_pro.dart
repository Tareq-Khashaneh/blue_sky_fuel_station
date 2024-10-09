
import '../../core/constants/typedef.dart';
import '../models/proffer_sale_model.dart';
import '../repositories/proffer_sale_repo.dart';

class ProfferSalePro {
  final ProfferSaleRepo _profferSaleRepo;

  ProfferSalePro({required ProfferSaleRepo profferSaleRepo})
      : _profferSaleRepo = profferSaleRepo;
  Future<ProfferSaleModel?> profferSale(parameters params) async {
    try {
      Map<String, dynamic>? data = await _profferSaleRepo.profferSale(params);
      if (data != null) {
        return ProfferSaleModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("error in getCardQuota  $e");
      return null;
    }
  }
}
