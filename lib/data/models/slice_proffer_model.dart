


import '../../core/constants/typedef.dart';

class SliceProfferModel{
  final String shortcut;
  final String shortcutAr;
  var remaining;

  SliceProfferModel({required this.shortcut, required this.shortcutAr, required this.remaining});

  factory SliceProfferModel.fromJson(parameters json)
  => SliceProfferModel(shortcut: json['shortcut'], shortcutAr: json['shortcut_ar'], remaining: json['remaining']);
}