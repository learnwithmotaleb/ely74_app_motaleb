import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/color_constants.dart';
import 'package:market_place/core/constants/custom_space.dart';
import 'package:market_place/core/constants/fontsize_constant.dart';
import 'package:market_place/core/constants/padding_constant.dart';
import 'package:market_place/core/constants/text_style_constant.dart';


class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {this.inputFormatters,
      this.onFieldSubmitted,
      this.textEditingController,
      this.focusNode,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.cursorColor = AppColors.kPrimaryColor,
      this.borderColor = Colors.black,
      this.inputTextStyle,
      this.textAlignVertical = TextAlignVertical.center,
      this.textAlign = TextAlign.start,
      this.onChanged,
      this.maxLines = 1,
      this.validator,
      this.hintText  ,
      this.hintStyle,
      this.suffixIcon,
      this.suffixIconColor,
      this.isPassword = false,
      this.readOnly = false,
      this.maxLength,
      super.key,
      this.prefixIcon,
      this.onTap,
      this.isCollapsed,
      this.isDense,
      this.border,
      this.focusedBorder,
      this.enabledBorder,
      this.fillColor = AppColors.kPrimaryAccentColor,
      this.contentPadding = const EdgeInsets.only(left: 10),
      this.title,
      this.isEnable = true,
      this.height,
      this.isRequired = false,
      this.borderRadius, this.minLines});

  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final String? title;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final TextStyle? inputTextStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final double? borderRadius;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator? validator;
  final String? hintText;
  final TextStyle? hintStyle;

  final Color? suffixIconColor;
  final Color? fillColor;
  final Color? borderColor;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final OutlineInputBorder? border;

  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? enabledBorder;

  final bool isPassword;
  final bool? isEnable;
  final bool? isRequired;
  final EdgeInsetsGeometry contentPadding;
  final bool readOnly;
  final double? height;
  final int? maxLength;
  final bool? isCollapsed;
  final bool? isDense;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap; // Callback function for onTap

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? Row(
                children: [
                  Text(
                    widget.title ?? '',
                    style: poppinsSemiBold.copyWith(
                      color: AppColors.kBlackColor,
                        fontSize: getFontSizeSemiSmall()),
                  ),
                  widget.isRequired == true
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '*',
                            style: poppinsRegular.copyWith(
                                color: Colors.red,
                                fontSize: getFontSizeSemiSmall()),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            : const SizedBox.shrink(),
        widget.title != null ? space8H : const SizedBox.shrink(),
        SizedBox(
          height: widget.height, // Set the desired height here
          child: TextFormField(
            textAlign: widget.textAlign,
            onTap: widget.onTap,
            enabled: widget.isEnable,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onFieldSubmitted,
            readOnly: widget.readOnly,
            controller: widget.textEditingController,
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            cursorColor: widget.cursorColor,


            style: widget.inputTextStyle ??
                TextStyle(
                    color: AppColors.kLightTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: getFontSizeSemiSmall()),
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            obscureText: widget.isPassword ? obscureText : false,
            validator: widget.validator,
            decoration: InputDecoration(
              contentPadding: padding12H,  // Adjust vertical padding
              fillColor: widget.fillColor,
              isCollapsed: widget.isCollapsed,
              isDense: widget.isDense,
              errorMaxLines: 2,
              hintText: widget.hintText??AppStaticStrings.typeHere.tr,
              hintStyle: widget.hintStyle ??
                  TextStyle(
                      color: AppColors.kExtraLightTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: getFontSizeSemiSmall()),
              filled: true,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: toggle,
                      child: obscureText
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.kExtraLightTextColor,
                            )
                          : const Icon(Icons.visibility_outlined,
                              color: AppColors.kExtraLightTextColor),
                    )
                  : widget.suffixIcon,
              suffixIconColor: widget.suffixIconColor,
              disabledBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
    borderSide: BorderSide(
    color:  widget.borderColor ?? Colors.transparent, width: .5),
    ) ,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
                borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.transparent, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
                borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.transparent, width: .5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.r),
                borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.transparent, width: .5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
