import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/tech_series_feedback_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/features/common/form/common_form_widgets.dart';
import 'package:home_page/features/common/form/dropdown_field/presentation/dropdown_form_field.dart';
import 'package:home_page/features/common/form/radio_field/radio_form_field.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/home/application/home_service.dart';
import 'package:home_page/features/home/domain/tech_series_feedback_form_data.dart';

class TechSeriesFeedbackPage extends StatefulWidget {
  const TechSeriesFeedbackPage({super.key});

  @override
  State<TechSeriesFeedbackPage> createState() => _TechSeriesFeedbackPageState();
}

class _TechSeriesFeedbackPageState extends State<TechSeriesFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final Map<TechSeriesFeedbackFormInputKeys, GlobalKey> _formFieldKeys = {};
  final Map<TechSeriesFeedbackFormInputKeys, TextEditingController> _controllers = {};
  final Map<TechSeriesFeedbackFormInputKeys, FocusNode> _focusNodes = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var e in TechSeriesFeedbackFormInputKeys.values) {
      const String initialText = '';
      _controllers[e] = TextEditingController(text: initialText);
      _focusNodes[e] = FocusNode();
      _formFieldKeys[e] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _controllers.values.map((e) => e.dispose());
    _focusNodes.values.map((e) => e.dispose());
    _controllers.clear();
    _focusNodes.clear();
    _formFieldKeys.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortraitOrientation = isPortraitMode(context);
    final argument = ModalRoute.of(context)!.settings.arguments
        as TechSeriesFeedbackPageArgument;
    final techSeriesTitles = argument.techSeriesTitles;
    final initialValue = argument.initialValue;
    return Scaffold(
      appBar: appBar(shouldAddBackButton: true),
      body: CustomLayoutBuilder(
        scrollController: _scrollController,
        sliverChildList: [
          Form(
            key: _formKey,
            onWillPop: () async {
              return await _exitConfirmationDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Center(
                child: SizedBox(
                  width:
                      isPortraitOrientation ? null : formWidthForLandscapeMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formInfoCard(
                        headerText: techSeriesFeedbackFormHeaderText,
                        bodyText: techSeriesFeedbackFormDescriptionText,
                        context: context,
                      ),
                      verticalSpace(height: sectionSpacingHeight),
                      _formInputCards(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        techSeriesTitles: techSeriesTitles,
                        initialValue: initialValue!,
                      ),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      formButtons(
                        context: context,
                        submitForm: _submitForm,
                        clearForm: _clearForm,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        refresh: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _formInputCards({
    required Map<TechSeriesFeedbackFormInputKeys, TextEditingController> controllers,
    required Map<TechSeriesFeedbackFormInputKeys, FocusNode> focusNodes,
    required List<String> techSeriesTitles,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.techTalkTopic],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.techTalkTopic]!,
          items: techSeriesTitles,
          labelText: techTalkTopicFieldText,
          required: true,
          initialValue: initialValue,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.understanding],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.understanding],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.understanding],
          labelText: understandingFieldText,
          values: List.generate(10, (index) {
            switch (index) {
              case 0: return understandingField1;
              case 4: return understandingField5;
              case 9: return understandingField10;
              default: return '${index + 1}';
            }
          }),
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.satisfied],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.satisfied],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.satisfied],
          labelText: satisfiedFieldText,
          values: List.generate(10, (index) {
            switch (index) {
              case 0: return satisfiedField1Poor;
              case 9: return satisfiedField10Excellent;
              default: return '${index + 1}';
            }
          }),
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.overall],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.overall],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.overall],
          labelText: overallFieldText,
          values: const [
            overallFieldOption1,
            overallFieldOption2,
            overallFieldOption3,
            otherRadioButtonText,
          ],
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.logistics],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.logistics],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.logistics],
          labelText: logisticsFieldText,
          values: const [
            logisticsFieldOption1,
            logisticsFieldOption2,
            logisticsFieldOption3,
            logisticsFieldOption4,
            logisticsFieldOption5,
            otherRadioButtonText,
          ],
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.duration],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.duration],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.duration],
          labelText: durationFieldText,
          values: List.generate(10, (index) {
            switch (index) {
              case 0: return durationField1TooShort;
              case 9: return durationField10TooLong;
              default: return '${index + 1}';
            }
          }),
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.takeaway],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.takeaway],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.takeaway],
          labelText: takeawayFieldText,
          values: const [
            takeawayFieldOption1,
            takeawayFieldOption2,
            takeawayFieldOption3,
            takeawayFieldOption4,
            otherRadioButtonText,
          ],
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.followUp],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.followUp],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.followUp],
          labelText: followUpFieldText,
          values: const [
            followUpFieldOption1,
            followUpFieldOption2,
            followUpFieldOption3,
            followUpFieldOption4,
            otherRadioButtonText,
          ],
          required: true,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.recommend],
          controller: _controllers[TechSeriesFeedbackFormInputKeys.recommend],
          focusNode: _focusNodes[TechSeriesFeedbackFormInputKeys.recommend],
          labelText: recommendFieldText,
          values: const [
            recommendFieldOption1,
            recommendFieldOption2,
            recommendFieldOption3,
            recommendFieldOption4,
            otherRadioButtonText,
          ],
          required: true,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.particularFeedback],
          labelText: particularFeedbackFieldText,
          focusNode: focusNodes[TechSeriesFeedbackFormInputKeys.particularFeedback],
          controller: controllers[TechSeriesFeedbackFormInputKeys.particularFeedback],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.otherTopics],
          labelText: otherTopicsFieldText,
          focusNode: focusNodes[TechSeriesFeedbackFormInputKeys.otherTopics],
          controller: controllers[TechSeriesFeedbackFormInputKeys.otherTopics],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: _formFieldKeys[TechSeriesFeedbackFormInputKeys.suggestion],
          labelText: suggestionFieldText,
          focusNode: focusNodes[TechSeriesFeedbackFormInputKeys.suggestion],
          controller: controllers[TechSeriesFeedbackFormInputKeys.suggestion],
          context: context,
        ),
      ],
    );
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formValidation();
    } else {
      for (var key in TechSeriesFeedbackFormInputKeys.values) {
        setState(() {
          _isLoading = false;
        });
        final formField = _formFieldKeys[key];
        final controller = _controllers[key];
        final focusNode = _focusNodes[key];
        if (controller != null && formField != null) {
          final radioFormFieldState = formField.currentState as RadioFormFieldState?;
          if (radioFormFieldState != null) {
            await scrollToAWidget(formField);
            break;
          }
          if (validateTextField(controller.text) != null &&
              focusNode != null &&
              focusNode.canRequestFocus) {
            focusNode.requestFocus();
          }
        }
      }
    }
  }

  void _formValidation() async {
    final Map<TechSeriesFeedbackFormInputKeys, String> feedbackData = {};
    for (var key in TechSeriesFeedbackFormInputKeys.values) {
      final formField = _formFieldKeys[key]!;
      switch (key) {
        case TechSeriesFeedbackFormInputKeys.techTalkTopic:
          {
            final dropDownFormFieldState = formField.currentState as DropdownFormFieldState;
            feedbackData[key] = dropDownFormFieldState.selectedValue!;
            break;
          }
        case TechSeriesFeedbackFormInputKeys.understanding:
        case TechSeriesFeedbackFormInputKeys.satisfied:
        case TechSeriesFeedbackFormInputKeys.overall:
        case TechSeriesFeedbackFormInputKeys.logistics:
        case TechSeriesFeedbackFormInputKeys.duration:
        case TechSeriesFeedbackFormInputKeys.takeaway:
        case TechSeriesFeedbackFormInputKeys.followUp:
        case TechSeriesFeedbackFormInputKeys.recommend:
          {
            final radioFormFieldState = formField.currentState as RadioFormFieldState;
            radioFormFieldState.saveState();
            if (radioFormFieldState.selectedValue != null) {
              if (radioFormFieldState.selectedValue == otherRadioButtonText
                  && validateTextField(_controllers[key]!.text) == null) {
                feedbackData[key] = _controllers[key]!.text;
              } else {
                feedbackData[key] = radioFormFieldState.selectedValue!;
              }
            } else {
              await scrollToAWidget(formField);
              setState(() {
                _isLoading = false;
              });
              return;
            }
            break;
          }
        default: feedbackData[key] = _controllers[key]!.text;
      }
    }

    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    feedbackData[TechSeriesFeedbackFormInputKeys.email] = userEmail ?? "";
    TechSeriesFeedbackFormData data = TechSeriesFeedbackFormData.from(feedbackData);
    if (context.mounted) {
      HomeService().postTechSeriesFeedbackFormData(
        data,
        context: context,
        (status) {
          setState(() {
            _isLoading = false;
          });
          if (status == 'SUCCESS') {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(content: const Text(errorFetching)),
            );
          }
        },
      );
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    for (var key in TechSeriesFeedbackFormInputKeys.values) {
      switch (key) {
        case TechSeriesFeedbackFormInputKeys.techTalkTopic:
          {
            final dropDownFormFieldState = _formFieldKeys[key]!.currentState as DropdownFormFieldState;
            dropDownFormFieldState.clearState();
            break;
          }
        case TechSeriesFeedbackFormInputKeys.understanding:
        case TechSeriesFeedbackFormInputKeys.satisfied:
        case TechSeriesFeedbackFormInputKeys.overall:
        case TechSeriesFeedbackFormInputKeys.logistics:
        case TechSeriesFeedbackFormInputKeys.duration:
        case TechSeriesFeedbackFormInputKeys.takeaway:
        case TechSeriesFeedbackFormInputKeys.followUp:
        case TechSeriesFeedbackFormInputKeys.recommend:
          {
            final radioFormFieldState = _formFieldKeys[key]!.currentState as RadioFormFieldState;
            radioFormFieldState.clearState();
            _controllers[key]!.text = '';
            break;
          }
        default: _controllers[key]!.text = '';
      }
    }
    Navigator.pop(context);
    scrollToTop(_scrollController);
  }

  Future<bool> _exitConfirmationDialog(BuildContext context) async {
    bool? shouldShowDialog = false;
    for (var e in TechSeriesFeedbackFormInputKeys.values) {
      switch (e) {
        case TechSeriesFeedbackFormInputKeys.understanding:
        case TechSeriesFeedbackFormInputKeys.satisfied:
        case TechSeriesFeedbackFormInputKeys.overall:
        case TechSeriesFeedbackFormInputKeys.logistics:
        case TechSeriesFeedbackFormInputKeys.duration:
        case TechSeriesFeedbackFormInputKeys.takeaway:
        case TechSeriesFeedbackFormInputKeys.followUp:
        case TechSeriesFeedbackFormInputKeys.recommend:
          {
            final radioFormFieldState = _formFieldKeys[e]!.currentState as RadioFormFieldState;
            if (radioFormFieldState.selectedValue != null) {
              shouldShowDialog = true;
            }
            break;
          }
        default:
          {
            if (validateTextField(_controllers[e]!.text) == null) {
              shouldShowDialog = true;
              break;
            }
          }
      }
    }
    if (shouldShowDialog!) {
      shouldShowDialog = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(alertAreYouSureTitleText),
            content: sectionBody(
              clearFormDialogContentText,
              context: context,
              maxLines: 5,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(noDialogActionText),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(yesDialogActionText),
              ),
            ],
          );
        },
      );
      return shouldShowDialog ?? false;
    }
    // pop directly
    return true;
  }
}
