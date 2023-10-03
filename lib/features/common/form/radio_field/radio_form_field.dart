import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/common/form/common_form_widgets.dart';

class RadioFormField extends StatefulWidget {
  const RadioFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.required,
    required this.values,
    this.groupValue,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String labelText;
  final bool required;
  final List<String> values;
  final String? groupValue;

  @override
  RadioFormFieldState createState() => RadioFormFieldState();
}

class RadioFormFieldState extends State<RadioFormField> {
  late String? _selectedValue;
  String? get selectedValue => _selectedValue;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.groupValue;
  }

  void saveState() {
    setState(() {
      _isSelected = _selectedValue == null;
    });
  }

  void clearState({String? defaultValue}) {
    setState(() {
      _selectedValue = defaultValue;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.labelText,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                if (widget.required)
                  const Text(
                    ' $requiredText',
                    style: TextStyle(color: Colors.red),
                  )
              ],
            ),
            verticalSpace(height: formFieldVerticalSpacing),
            _buildRadioButtons(
              _selectedValue,
              values: widget.values,
              setValue: (value) {
                setState(() {
                  _selectedValue = value;
                });
                if (value == otherRadioButtonText) {
                  widget.focusNode?.requestFocus();
                }
              },
            ),
            verticalSpace(height: formFieldVerticalSpacing),
            if (_isSelected) requiredFormField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButtons(
    String? groupValue, {
    required List<String> values,
    Function(String?)? setValue,
  }) {
    return Column(
      children: List.generate(
        values.length,
        (index) => _customRadioListTile(
          value: values[index],
          title: values[index],
          groupValue: groupValue,
          setValue: setValue,
          shouldShowOtherTextField: values[index] == otherRadioButtonText,
        ),
      ),
    );
  }

  Widget _customRadioListTile({
    required String value,
    required String title,
    required String? groupValue,
    Function(String?)? setValue,
    bool shouldShowOtherTextField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: formFieldVerticalSpacing),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: setValue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Text(
                title.toString(),
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                maxLines: 5,
              ),
              onTap: () {
                setValue!(value);
              },
            ),
          ),
          if (shouldShowOtherTextField) horizontalSpace(),
          if (shouldShowOtherTextField)
            Expanded(
              flex: 4,
              child: textFormField(
                hintText: null,
                focusNode: widget.focusNode,
                controller: widget.controller,
                errorText: requiredErrorText,
                validator: (text) {
                  if (groupValue == value) {
                    return validateTextField(text);
                  }
                  return null;
                },
                onTap: () {
                  if (shouldShowOtherTextField) {
                    setValue!(value);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
