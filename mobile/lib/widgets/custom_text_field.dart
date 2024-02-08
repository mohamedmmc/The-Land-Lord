import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../services/theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? fieldController;
  final String? hintText;
  final String? labelText;
  final TextInputType? textInputType;
  final bool isTextArea;
  final bool isOptional;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double? height;
  final FocusNode? focusNode;
  final bool? readOnly;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final double? topPadding;
  final double? textFontSize;
  final int? maxLength;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final bool outlinedBorder;
  final bool enableFloatingLabel;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.fieldController,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.textInputType,
    this.isTextArea = false,
    this.isPassword = false,
    this.isOptional = false,
    this.readOnly,
    this.height,
    this.focusNode,
    this.enabled = true,
    this.topPadding,
    this.textFontSize,
    this.maxLength,
    this.textAlign,
    this.autofocus = false,
    this.prefixIcon,
    this.outlinedBorder = true,
    this.enableFloatingLabel = false,
    this.onTapOutside,
    this.textCapitalization,
    this.inputFormatters,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  CustomTextFieldState createState() => CustomTextFieldState(isPassword);
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  CustomTextFieldState(this._obscureText);

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          if (widget.isOptional)
            Positioned(
              top: 10,
              right: 5,
              child: Text(
                'lbl_optional'.tr,
                style: const TextStyle(fontSize: 8),
              ),
            ),
          Container(
            padding: EdgeInsets.only(top: widget.topPadding ?? Paddings.extraLarge),
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              maxLength: widget.maxLength,
              onTapOutside: widget.onTapOutside,
              inputFormatters: widget.inputFormatters,
              style: TextStyle(fontSize: widget.textFontSize),
              enabled: widget.enabled,
              textDirection: widget.textInputType == TextInputType.phone ? TextDirection.ltr : null,
              focusNode: widget.focusNode,
              textCapitalization: widget.textCapitalization ?? TextCapitalization.words,
              keyboardType: widget.textInputType,
              textAlign: widget.textAlign ?? TextAlign.center,
              autofocus: widget.autofocus,
              maxLines: widget.isTextArea ? 5 : 1,
              onTap: widget.onTap,
              readOnly: widget.readOnly ?? widget.onTap != null,
              validator: widget.validator,
              onFieldSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                contentPadding: widget.outlinedBorder
                    ? const EdgeInsets.only(right: Paddings.extraLarge, left: Paddings.large, top: Paddings.extraLarge)
                    : const EdgeInsets.only(bottom: Paddings.small),
                labelText: widget.labelText,
                alignLabelWithHint: true,
                label: widget.enableFloatingLabel ? Text(widget.hintText ?? '') : null,
                border: widget.outlinedBorder ? const OutlineInputBorder() : null,
                hintText: widget.hintText,
                hintStyle: AppFonts.x14Regular.copyWith(color: kNeutralColor.withAlpha(150)),
                prefixIcon: widget.prefixIcon,
                constraints: BoxConstraints(maxHeight: widget.height ?? double.infinity),
                suffixIcon: widget.suffixIcon ??
                    (widget.isPassword
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: widget.height != null
                                ? Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    size: 0.5 * widget.height!,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: Theme.of(context).primaryColor,
                                  ),
                          )
                        : null),
              ),
              controller: widget.fieldController,
              obscureText: _obscureText,
            ),
          ),
        ],
      );
}
