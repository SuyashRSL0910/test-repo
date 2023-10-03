import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

const _menuMaxHeight = 300.0;

class DropdownFormField extends StatefulWidget {
  const DropdownFormField({
    super.key,
    required this.focusNode,
    required this.items,
    required this.required,
    required this.labelText,
    required this.initialValue,
  });

  final FocusNode focusNode;
  final List<String> items;
  final bool required;
  final String labelText;
  final String initialValue;

  @override
  State<DropdownFormField> createState() => DropdownFormFieldState();
}

class DropdownFormFieldState extends State<DropdownFormField> {
  final List<DropdownMenuItem<String>> _menuItems = [];
  String? _selectedValue;

  String? get selectedValue => _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _buildMenuItems();
  }

  void clearState() {
    setState(() {
      _selectedValue = widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: formCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(formCardRadius),
        side: BorderSide(
          color: cardLightBorderColor!,
          width: formCardBorderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(cardContentPadding),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // requests focus of formField
                widget.focusNode.requestFocus();
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: widget.labelText),
                    if (widget.required)
                      const TextSpan(
                        text: ' $requiredText',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
            verticalSpace(height: formFieldVerticalSpacing),
            DropdownButtonFormField<String>(
              isExpanded: true,
              menuMaxHeight: _menuMaxHeight,
              items: _menuItems,
              onChanged: (value) {
                if (value != null) {
                  _selectedValue = value;
                  widget.focusNode.unfocus();
                }
              },
              value: _selectedValue,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: cardContentPadding,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(formCardRadius),
                  borderSide: BorderSide(
                    color: cardLightBorderColor!,
                    width: formCardBorderWidth,
                  ),
                ),
              ),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    overflow: TextOverflow.ellipsis,
                    color: bodyTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildMenuItems() {
    _menuItems.add(DropdownMenuItem(
      value: chooseDropdownDefaultValue,
      enabled: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(chooseDropdownDefaultValue),
          verticalSpace(height: 5),
          const Divider(thickness: 2, height: 2),
        ],
      ),
    ));
    _menuItems.addAll(widget.items.map(
      (item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      ),
    ));
  }
}
