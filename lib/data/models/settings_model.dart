
import '../../core/constants/typedef.dart';

class SettingsModel {
  final int? printTwice;
  final int? pinCode;
  final int? offlineMode;
  final int? openTicket;
  final int? exceedBalance;
  final int? printRemainingBalance;
  final int? printerFontSize;
  final int? plateNumber;
  final int? onlyMobile;
  final int? epayment;
  final int? batch;
  final int? actvOff;
  final int? offDuration;
  final int? enableDeliver;
  final int? cardMasterRequired;
  final int? isGarage;
  final int? isBakery;
  SettingsModel({required this.printTwice,required this.pinCode, required this.offlineMode, required this.openTicket, required this.exceedBalance, required this.printRemainingBalance, required this.printerFontSize, required this.plateNumber, required this.onlyMobile, required this.epayment, required this.batch, required this.actvOff, required this.offDuration, required this.enableDeliver, required this.cardMasterRequired, required this.isGarage, required this.isBakery});
  factory SettingsModel.fromJson(parameters json)
  => SettingsModel(printTwice: json['print_twice'],
      pinCode: json['pin_code'],
      offlineMode: json['offline_mode'],
      openTicket: json['open_ticket'],
      exceedBalance: json['exceed_balance'],
      printRemainingBalance: json['print_remaining_balance'],
      printerFontSize: json['printer_font_size'],
      plateNumber: json['plate_number'],
      onlyMobile: json['only_mobile'],
      epayment: json['epayment'],
      batch: json['batch'], actvOff: json['actvOff'],
      offDuration: json['off_duration'],
  enableDeliver: json['enable_deliver'],
      cardMasterRequired: json['card_master_required'],
      isGarage: json['is_garage'],
      isBakery: json['is_bakery']);
}