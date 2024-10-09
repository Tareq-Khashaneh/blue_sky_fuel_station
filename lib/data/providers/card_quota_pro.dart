
import '../../core/constants/typedef.dart';
import '../models/card_quota_model.dart';
import '../repositories/card_quota_repo.dart';

class CardQuotPro {
  final CardQuotaRepo _cardQuotaRepo;

  CardQuotPro({required CardQuotaRepo cardQuotaRepo})
      : _cardQuotaRepo = cardQuotaRepo;
  Future<CardQuotaModel?> getCardQuota(parameters params) async {
    try {
      Map<String, dynamic>? data = await _cardQuotaRepo.getCardQuota(params);
      if (data != null) {
        return CardQuotaModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("error in getCardQuota  $e");
      return null;
    }
  }
}
