import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:the_land_lord_website/utils/constants/constants.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/theme/theme.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  final String? hint;
  final String? label;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final Function(bool)? isMenuOpen;
  final String? Function(T?)? validator;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? dropdownWidth;
  final double? dropdownMaxHeight;
  final int? elevation;
  final bool isRequired;
  final bool isDisabled;
  final bool labelIncluded;
  final bool noLabel;
  final bool labelAlongside;
  final bool addWidthFallBack;
  final double? textFontSize;
  final Widget? customButton;
  final Widget? icon;
  final EdgeInsets? itemPadding;
  final bool includeScrollbar;
  final Offset? offset;
  final EdgeInsetsGeometry? dropdownScrollPadding;
  final bool dropDownWithDecoration;
  final double itemHeight;
  final int flexLabel;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn;
  final Color? overlayColor;

  const CustomDropDownMenu({
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.hint,
    this.dropdownScrollPadding,
    this.customButton,
    this.icon,
    this.itemPadding,
    this.isMenuOpen,
    this.label,
    this.validator,
    this.includeScrollbar = false,
    this.noLabel = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.labelIncluded = false,
    this.labelAlongside = false,
    this.dropDownWithDecoration = true,
    this.addWidthFallBack = true,
    this.buttonWidth,
    this.buttonHeight = 35,
    this.dropdownWidth,
    this.dropdownMaxHeight,
    this.offset,
    this.elevation,
    this.textFontSize,
    this.itemHeight = 48,
    this.flexLabel = 3,
    this.searchMatchFn,
    super.key,
    this.overlayColor,
  }) : assert(
          hint == null || customButton == null,
          'Please ether use hintWidget or customButton',
        );

  @override
  Widget build(BuildContext context) {
    final double width = buttonWidth != null && buttonWidth! < 300 && addWidthFallBack ? 300 : buttonWidth ?? 300;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!noLabel && !labelIncluded && !labelAlongside)
          Padding(
            padding: const EdgeInsets.only(bottom: Paddings.small),
            child: RichText(
              text: TextSpan(
                text: label,
                style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: AppFonts.x15Bold.copyWith(color: kErrorColor),
                    ),
                ],
              ),
            ),
          ),
        SizedBox(
          width: labelAlongside ? width + 80 : width / 2,
          height: buttonHeight,
          child: labelIncluded
              ? _WrapWithBorder(
                  dropDownWithDecoration: dropDownWithDecoration,
                  buttonHeight: buttonHeight,
                  buttonWidth: width,
                  child: _BuildDropDownButton(
                    itemHeight: itemHeight,
                    dropDownWithDecoration: dropDownWithDecoration,
                    items: items,
                    isMenuOpen: isMenuOpen,
                    dropdownScrollPadding: dropdownScrollPadding,
                    onChanged: onChanged,
                    buttonHeight: buttonHeight,
                    buttonWidth: width,
                    customButton: customButton,
                    dropdownMaxHeight: dropdownMaxHeight,
                    dropdownWidth: dropdownWidth,
                    elevation: elevation,
                    hint: hint,
                    isDisabled: isDisabled,
                    icon: icon,
                    includeScrollbar: includeScrollbar,
                    isRequired: isRequired,
                    itemPadding: itemPadding,
                    label: label,
                    labelAlongside: labelAlongside,
                    labelIncluded: labelIncluded,
                    offset: offset,
                    flexLabel: flexLabel,
                    searchMatchFn: searchMatchFn,
                    overlayColor: overlayColor,
                    selectedItem: selectedItem,
                  ),
                )
              : _BuildDropDownButton(
                  itemHeight: itemHeight,
                  dropDownWithDecoration: dropDownWithDecoration,
                  items: items,
                  isMenuOpen: isMenuOpen,
                  isDisabled: isDisabled,
                  onChanged: onChanged,
                  buttonHeight: buttonHeight,
                  buttonWidth: width,
                  customButton: customButton,
                  dropdownMaxHeight: dropdownMaxHeight,
                  dropdownWidth: dropdownWidth,
                  elevation: elevation,
                  hint: hint,
                  icon: icon,
                  includeScrollbar: includeScrollbar,
                  isRequired: isRequired,
                  itemPadding: itemPadding,
                  label: label,
                  labelAlongside: labelAlongside,
                  labelIncluded: labelIncluded,
                  offset: offset,
                  flexLabel: flexLabel,
                  searchMatchFn: searchMatchFn,
                  overlayColor: overlayColor,
                  selectedItem: selectedItem,
                ),
        ),
      ],
    );
  }
}

class _BuildDropDownButton<T> extends StatelessWidget {
  final String? hint;
  final String? label;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final Function(bool)? isMenuOpen;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? dropdownWidth;
  final double? dropdownMaxHeight;
  final int? elevation;
  final bool isRequired;
  final bool labelIncluded;
  final bool labelAlongside;
  final bool dropDownWithDecoration;
  final Widget? customButton;
  final Widget? icon;
  final EdgeInsets? itemPadding;
  final bool includeScrollbar;
  final bool isDisabled;
  final Offset? offset;
  final EdgeInsetsGeometry? dropdownScrollPadding;
  final double? itemHeight;
  final int flexLabel;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn;
  final Color? overlayColor;

  const _BuildDropDownButton({
    required this.items,
    required this.onChanged,
    required this.flexLabel,
    this.selectedItem,
    this.hint,
    this.isDisabled = false,
    this.dropdownScrollPadding,
    this.label,
    this.isMenuOpen,
    this.buttonWidth,
    this.buttonHeight,
    this.dropdownWidth,
    this.dropdownMaxHeight,
    this.elevation,
    this.isRequired = false,
    this.labelIncluded = false,
    this.labelAlongside = false,
    this.dropDownWithDecoration = true,
    this.customButton,
    this.icon,
    this.itemPadding,
    this.includeScrollbar = false,
    this.offset,
    this.itemHeight,
    this.searchMatchFn,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final isCurrentItem = selectedItem != null && (hint?.contains(selectedItem.toString()) ?? false) || selectedItem == hint && selectedItem != null;
    return DecoratedBox(
      decoration: const BoxDecoration(color: kNeutralColor100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (labelAlongside)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Text(
                label ?? 'Please provide a label',
                style: AppFonts.x14Regular.copyWith(color: kNeutralColor),
              ),
            ),
          _WrapWithBorder(
            dropDownWithDecoration: dropDownWithDecoration,
            buttonWidth: (buttonWidth ?? 100) / 2,
            child: SizedBox(
              width: (buttonWidth ?? 100) / 2,
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: const ScrollbarThemeData().copyWith(
                    thumbColor: MaterialStateProperty.all(kPrimaryColor),
                  ),
                  hoverColor: Colors.transparent,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<T>(
                    dropdownStyleData: DropdownStyleData(
                      offset: offset ?? const Offset(0, -1),
                      elevation: elevation ?? 8,
                      scrollPadding: dropdownScrollPadding,
                      maxHeight: dropdownMaxHeight,
                      width: dropdownWidth,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(RadiusSize.regular), color: Colors.white),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(1.5),
                        thickness: const MaterialStatePropertyAll(3),
                        thumbVisibility: MaterialStatePropertyAll(includeScrollbar),
                      ),
                    ),
                    customButton: customButton,
                    isExpanded: true,
                    items: isDisabled
                        ? []
                        : items
                            .map<DropdownMenuItem<T>>(
                              (value) => DropdownMenuItem<T>(
                                value: value,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: selectedItem != null && selectedItem.toString() == value.toString() ? kPrimaryColor : null,
                                    borderRadius: smallRadius,
                                  ),
                                  child: Center(
                                    child: Text(value.toString(), style: AppFonts.x14Bold),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: isDisabled ? (value) {} : onChanged,
                    iconStyleData: IconStyleData(icon: icon ?? const Icon(Icons.arrow_drop_down, size: 25, color: kNeutralColor)),
                    hint: labelIncluded
                        ? Row(
                            children: [
                              if (labelIncluded) ...[
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: flexLabel,
                                  child: Center(child: Text(label ?? '', style: AppFonts.x14Regular)),
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(
                                  width: .6,
                                  height: 50,
                                  child: DecoratedBox(decoration: BoxDecoration(color: kNeutralColor)),
                                ),
                              ],
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    hint ?? '',
                                    style: AppFonts.x14Regular.copyWith(color: isCurrentItem ? kBlackColor : kNeutralColor.withAlpha(150)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              hint ?? '',
                              style: AppFonts.x14Regular.copyWith(color: isCurrentItem ? kBlackColor : kNeutralColor.withAlpha(150)),
                            ),
                          ),
                    buttonStyleData: ButtonStyleData(
                      height: buttonHeight,
                      width: buttonWidth,
                      decoration: isDisabled
                          ? BoxDecoration(
                              color: kNeutralColor,
                              border: Border.all(color: kNeutralColor, width: .6),
                              borderRadius: const BorderRadius.all(Radius.circular(RadiusSize.regular)),
                            )
                          : null,
                      overlayColor: overlayColor != null ? MaterialStatePropertyAll(overlayColor) : null,
                    ),
                    menuItemStyleData: MenuItemStyleData(height: itemHeight!, padding: itemPadding),
                    onMenuStateChange: (isOpen) {
                      isMenuOpen?.call(isOpen);
                      if (!isOpen) searchController.clear();
                    },
                    dropdownSearchData: searchMatchFn == null
                        ? null
                        : DropdownSearchData(
                            searchController: searchController,
                            searchMatchFn: searchMatchFn,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.small),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: searchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: 'Search for an item...',
                                  hintStyle: AppFonts.x14Bold.copyWith(color: kNeutralColor),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kNeutralColor)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kNeutralColor)),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WrapWithBorder extends StatelessWidget {
  final Widget child;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool? dropDownWithDecoration;

  const _WrapWithBorder({
    required this.child,
    this.buttonWidth = 100,
    this.buttonHeight = 40,
    this.dropDownWithDecoration,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: DecoratedBox(
          decoration: dropDownWithDecoration!
              ? BoxDecoration(
                  border: Border.all(
                    color: kNeutralColor,
                    width: 0.6,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(RadiusSize.regular)),
                )
              : const BoxDecoration(),
          child: child,
        ),
      );
}
