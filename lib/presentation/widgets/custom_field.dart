import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimensions.dart';

class CustomField extends StatefulWidget {
   CustomField({super.key, required this.label, required this.prefixIcon, this.onChange,  this.validator, this.isSecure,  this.keyboardType,this.inputFormatters,this.controller, this.labelColor, this.filledColor, this.iconColor,this.errorColor = AppColors.kWhiteColor});
  final String label;
  final IconData prefixIcon;
  final Function(String)? onChange;
  TextInputType? keyboardType;
  TextEditingController? controller;
  late bool? isSecure;
   final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final Color? filledColor;
  final Color? iconColor;
  Color errorColor  ;
  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: widget.labelColor ?? Colors.black, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: Dimensions.screenHeight * 0.01,
        ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.filledColor ?? AppColors.kWhiteColor.withOpacity(0.5),
            errorStyle:  TextStyle(
              color: widget.errorColor
            ),
            prefixIcon: Icon(widget.prefixIcon,
                color: widget.iconColor ?? AppColors.kMainColorGreenLighter),
            contentPadding: EdgeInsets.all(Dimensions.contentPadding044),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(Dimensions.screenHeight * 0.05)),
                borderSide: BorderSide.none),
          ),
          onChanged: widget.onChange,
          validator: widget.validator,
        ),
      ],
    );
  }
}
