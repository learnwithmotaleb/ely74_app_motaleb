import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_place/core/components/custom_button.dart';
import 'package:market_place/core/components/custom_button_tap.dart';
import 'package:market_place/core/constants/app_static_strings.dart';
import 'package:market_place/core/constants/custom_text.dart';
import 'package:market_place/core/helper/helper_function.dart';

import '../constants/color_constants.dart';
import '../constants/custom_space.dart';
import '../constants/fontsize_constant.dart';
import '../constants/padding_constant.dart';
import '../constants/text_style_constant.dart';


class CustomDropdown<T> extends StatefulWidget {
  final String? title;
  final String? hintText;
  final Color? borderColor;
  final Color? iconColor;
  final Color? fillColor;
  final Color? hintColor;
  final bool? isRequired;
  final bool? isLoading;
  final double? radius;
  final T? selectedValue;
  final List<T>? items;
  final String Function(T)? displayText; // Dynamic list of items
  final ValueChanged<T?>? onChanged; // Callback for selected value
  final String? Function(T?)? validator;
final Function()? onTap;
  const CustomDropdown({
    super.key,
    this.title,
    this.hintText,
    this.borderColor,
    this.fillColor,
    this.hintColor,
    this.radius,
    this.iconColor,
    this.items, // Pass dropdown items dynamically
    this.onChanged,
    this.selectedValue,
    this.isRequired = false,
    this.isLoading = false,
    this.displayText,
    this.validator, this.onTap, // Selected value managed externally
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
        validator: widget.validator,
        initialValue: widget.selectedValue,
        // Enable auto-validation to validate on change
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<T> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.title != null
                  ? Row(
                children: [
                  Text(
                    widget.title ?? '',
                    style: poppinsSemiBold.copyWith(
                      color: AppColors.kBlackColor,
                      fontSize: getFontSizeSemiSmall(),
                    ),
                  ),
                  widget.isRequired == true
                      ? Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '*',
                      style: poppinsRegular.copyWith(
                        color: Colors.red,
                        fontSize: getFontSizeSemiSmall(),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              )
                  : const SizedBox.shrink(),
              widget.title != null ? space8H : const SizedBox.shrink(),
              Container(
                padding: padding12H,
                decoration: BoxDecoration(
                  color: widget.fillColor ?? AppColors.kWhiteColor,
                  border: Border.all(
                    width: .5,
                    color:
                    state.hasError
                        ? AppColors.kRedColor
                        : widget.borderColor ??
                        AppColors.kExtraLightGreyTextColor,
                  ),
                  borderRadius: BorderRadius.circular(widget.radius ?? 6.r),
                ),
                child: ButtonTapWidget(
                  onTap:widget.onTap??(){
                    if(widget.isLoading==false && (widget.items==null||widget.items!.isEmpty)){
                      showCustomSnackbar(title: "Not Found", message: "Drop down item List is Empty",type: SnackBarType.failed);
                    }
                  },
                  child: DropdownButton<T>(
                    dropdownColor: AppColors.kWhiteColor,
                    padding: EdgeInsets.zero,
                    value: _getMatchedItem(widget.selectedValue, widget.items),
                    isExpanded: true,
                    underline: const SizedBox(), // Removes the default underline
                    style: poppinsMedium.copyWith(
                      color: widget.hintColor ?? AppColors.kLightTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: getFontSizeSemiSmall(),
                    ),
                    hint: Text(
                      widget.hintText ?? AppStaticStrings.selectOne.tr,
                      style: poppinsMedium.copyWith(
                        color: widget.hintColor ?? AppColors.kLightTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: getFontSizeSemiSmall(),
                      ),
                    ),
                    icon:
                    widget.isLoading == true
                        ? SizedBox(
                      height: 12,
                      width: 12,
                      child: DefaultProgressIndicator(
                        color: AppColors.kPrimaryColor,
                        strokeWidth: 2,
                      ),
                    )
                        : Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.iconColor ?? AppColors.kBlackColor,
                      size: 20.sp,
                    ),
                    items:
                    (widget.items ?? []).map((e) {
                      return DropdownMenuItem<T>(
                        value: e,
                        child: Text(
                          _getDisplayText(e),
                          style: poppinsMedium.copyWith(
                            color: AppColors.kBlackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: getFontSizeSemiSmall(),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Call both the widget's onChanged callback and update the form field state
                      // This is the critical change:
                      state.didChange(value); // Notify FormField first
                      if (widget.onChanged != null) {
                        widget.onChanged!(value); // Then notify parent
                      }
                      // Trigger validation immediately
                          if(value!=null){
                        state.validate();
                      }

                    },
                  ),
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: CustomText(
                    text: state.errorText ?? '',
                    style: poppinsRegular.copyWith(
                      color: AppColors.kRedColor,
                      fontSize: getFontSizeSmall(),
                    ),
                  ),
                ),
            ],
          );
        }
    );
  }
  T? _getMatchedItem(T? selected, List<T>? list) {
    if (selected == null || list == null) return null;

    for (final item in list) {
      if (item == selected) return item;

      // Fallback for models that use `sId` or similar identifier
      try {
        final selectedId = (selected as dynamic).sId;
        final itemId = (item as dynamic).sId;

        if (selectedId != null && itemId != null && selectedId == itemId) {
          return item;
        }
      } catch (_) {}
    }
    return null;
  }


  String _getDisplayText(T? item) {
    if (item == null) return '';
    // Use custom display text if provided, otherwise use toString()
    return widget.displayText?.call(item) ?? item.toString();
  }
}
