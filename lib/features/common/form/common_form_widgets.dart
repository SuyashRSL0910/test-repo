import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

Widget formInfoCard({
  required String headerText,
  required String bodyText,
  required BuildContext context,
}) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(formCardRadius),
      side: BorderSide(
        color: cardLightBorderColor!,
        width: formCardBorderWidth,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: formInfoCardHeaderBorderSize,
          decoration: const BoxDecoration(
            color: appThemeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(formCardRadius),
              topRight: Radius.circular(formCardRadius),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(cardContentPadding),
          child: Column(
            children: [
              sectionHeader(headerText, context: context),
              verticalSpace(height: sectionHeaderSpacingHeight),
              Text(
                bodyText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.all(cardContentPadding),
          child: Text(
            indicatesRequiredQuestionsText,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textFormFieldWithLabel({
  required String labelText,
  required FocusNode? focusNode,
  required TextEditingController? controller,
  required BuildContext context,
  GlobalKey? key,
  String? hintText = yourAnswerFormHintText,
  Widget? suffixIcon,
  Function()? onTap,
  String? Function(String?)? validator,
  bool readOnly = false,
  bool required = false,
}) {
  return Card(
    key: key,
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
          GestureDetector(
            onTap: () {
              // requests focus of formField
              focusNode?.requestFocus();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    labelText,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                if (required)
                  const Text(
                    ' $requiredText',
                    style: TextStyle(color: Colors.red),
                  )
              ],
            ),
          ),
          verticalSpace(height: formFieldVerticalSpacing),
          textFormField(
            focusNode: focusNode,
            controller: controller,
            onTap: onTap,
            suffixIcon: suffixIcon,
            readOnly: readOnly,
            validator: validator,
          ),
        ],
      ),
    ),
  );
}

Widget textFormField({
  required FocusNode? focusNode,
  required TextEditingController? controller,
  String? hintText = yourAnswerFormHintText,
  String? errorText = requiredErrorText,
  Function()? onTap,
  String? Function(String?)? validator,
  Widget? suffixIcon,
  bool readOnly = false,
}) {
  return TextFormField(
    maxLines: 5,
    minLines: 1,
    readOnly: readOnly,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
    ),
    onTapOutside: (event) {
      focusNode?.unfocus();
    },
    validator: validator,
    onTap: onTap,
    focusNode: focusNode,
    controller: controller,
    style: const TextStyle(fontSize: formTextFieldFontSize),
  );
}

Widget requiredFormField(BuildContext context) {
  return Row(
    children: [
      const Icon(Icons.error_outline, color: Colors.red,),
      horizontalSpace(width: sectionLabelSpacingWidth),
      Text(
        requiredErrorText,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}

Widget formButtons({
  required BuildContext context,
  Function()? submitForm,
  Function()? clearForm,
  required bool isLoading,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(
        onPressed: isLoading ? null : submitForm,
        child: isLoading
            ? const SpinKitRing(
                color: Colors.white,
                size: 25,
                lineWidth: 3,
              )
            : const Text(submitButtonText),
      ),
      OutlinedButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(clearFormDialogTitleText),
                content: sectionBody(
                  clearFormDialogContentText,
                  context: context,
                  maxLines: 5,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(cancelDialogActionText),
                  ),
                  TextButton(
                    onPressed: clearForm,
                    child: const Text(clearFormButtonText),
                  ),
                ],
              );
            },
          );
        },
        child: const Text(clearFormButtonText),
      ),
    ],
  );
}
