import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/form_response_submitted_page_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';
import 'package:home_page/features/common/form/common_form_widgets.dart';
import 'package:home_page/features/common/form/radio_field/radio_form_field.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/event_creation/application/event_creation_form_service.dart';
import 'package:home_page/features/event_creation/domain/event_creation_form_data.dart';

class EventCreationPage extends StatefulWidget {
  const EventCreationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EventCreationPage();
  }
}

class _EventCreationPage extends State<EventCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final Map<EventCreationFormInputKeys, GlobalKey> _formFieldKeys = {};
  final Map<EventCreationFormInputKeys, TextEditingController> _controllers = {};
  final Map<EventCreationFormInputKeys, FocusNode> _focusNodes = {};
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var e in EventCreationFormInputKeys.values) {
      late final String initialText;
      switch (e) {
        case EventCreationFormInputKeys.date:
          initialText = eventDateInitialText;
        case EventCreationFormInputKeys.startTime:
          initialText = eventTimeInitialText;
        case EventCreationFormInputKeys.endTime:
          initialText = eventTimeInitialText;
        default:
          initialText = '';
      }
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
    _scrollController.dispose();
    _focusNodes.clear();
    _formFieldKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortraitOrientation = isPortraitMode(context);
    return Scaffold(
      appBar: appBar(),
      drawer: const DrawerMenuPage(),
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
                  width: isPortraitOrientation ? null : formWidthForLandscapeMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formInfoCard(
                        headerText: eventCreationFormHeaderText,
                        bodyText: eventCreationFormDescriptionText,
                        context: context,
                      ),
                      verticalSpace(height: sectionSpacingHeight),
                      _formInputCards(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        formFieldKeys: _formFieldKeys,
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
    required Map<EventCreationFormInputKeys, TextEditingController> controllers,
    required Map<EventCreationFormInputKeys, FocusNode> focusNodes,
    required Map<EventCreationFormInputKeys, GlobalKey> formFieldKeys,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFormFieldWithLabel(
          key: formFieldKeys[EventCreationFormInputKeys.title],
          labelText: eventTitleText,
          focusNode: focusNodes[EventCreationFormInputKeys.title],
          controller: controllers[EventCreationFormInputKeys.title],
          required: true,
          validator: validateTextField,
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: formFieldKeys[EventCreationFormInputKeys.description],
          labelText: eventDescriptionText,
          focusNode: focusNodes[EventCreationFormInputKeys.description],
          controller: controllers[EventCreationFormInputKeys.description],
          required: true,
          validator: validateTextField,
          context: context,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[EventCreationFormInputKeys.location],
          controller: _controllers[EventCreationFormInputKeys.location],
          focusNode: _focusNodes[EventCreationFormInputKeys.location],
          labelText: eventLocationText,
          values: const [
            remoteRadioButtonText,
            otherRadioButtonText,
          ],
          required: true,
          groupValue: remoteRadioButtonText,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: formFieldKeys[EventCreationFormInputKeys.date],
          labelText: eventDateText,
          focusNode: focusNodes[EventCreationFormInputKeys.date],
          controller: controllers[EventCreationFormInputKeys.date],
          suffixIcon: const Icon(Icons.calendar_today),
          readOnly: true,
          required: true,
          context: context,
          onTap: () async {
            final date = await showDatePickerDialog(context);
            if (date != null && context.mounted) {
              controllers[EventCreationFormInputKeys.date]!.text =
                  dateFormat(date);
            }
          },
          validator: validateTextField,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: formFieldKeys[EventCreationFormInputKeys.startTime],
          labelText: eventStartTimeText,
          focusNode: focusNodes[EventCreationFormInputKeys.startTime],
          controller: controllers[EventCreationFormInputKeys.startTime],
          readOnly: true,
          required: true,
          suffixIcon: const Icon(Icons.access_time_outlined),
          onTap: () async {
            final time = await showTimePickerDialog(context);
            if (time != null) {
              controllers[EventCreationFormInputKeys.startTime]!.text = time;
            }
          },
          validator: validateTextField,
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          key: formFieldKeys[EventCreationFormInputKeys.endTime],
          labelText: eventEndTimeText,
          focusNode: focusNodes[EventCreationFormInputKeys.endTime],
          controller: controllers[EventCreationFormInputKeys.endTime],
          readOnly: true,
          required: true,
          suffixIcon: const Icon(Icons.access_time_outlined),
          onTap: () async {
            final time = await showTimePickerDialog(context);
            if (time != null) {
              controllers[EventCreationFormInputKeys.endTime]!.text = time;
            }
          },
          validator: validateTextField,
          context: context,
        ),
        verticalSpace(),
        RadioFormField(
          key: _formFieldKeys[EventCreationFormInputKeys.remoteLink],
          controller: _controllers[EventCreationFormInputKeys.remoteLink],
          focusNode: _focusNodes[EventCreationFormInputKeys.remoteLink],
          labelText: eventRemoteLinkText,
          values: const [
            googleMeetRadioButtonText,
            otherRadioButtonText,
          ],
          required: true,
          groupValue: googleMeetRadioButtonText,
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
      for (var key in EventCreationFormInputKeys.values) {
        setState(() {
          _isLoading = false;
        });
        final formField = _formFieldKeys[key];
        final controller = _controllers[key];
        final focusNode = _focusNodes[key];
        if (controller != null
            && formField != null
            && validateTextField(controller.text) != null) {
          await scrollToAWidget(formField);
          if (focusNode != null && focusNode.canRequestFocus) {
            focusNode.requestFocus();
          }
          break;
        }
      }
    }
  }

  void _clearForm() async {
    _formKey.currentState!.reset();
    for (var key in EventCreationFormInputKeys.values) {
      switch (key) {
        case EventCreationFormInputKeys.date:
          _controllers[key]!.text = eventDateInitialText;
        case EventCreationFormInputKeys.location:
          {
            final formField = _formFieldKeys[key]!.currentState as RadioFormFieldState;
            formField.clearState(defaultValue: remoteRadioButtonText);
            _controllers[key]!.text = '';
          }
        case EventCreationFormInputKeys.remoteLink:
          {
            final formField = _formFieldKeys[key]!.currentState as RadioFormFieldState;
            formField.clearState(defaultValue: googleMeetRadioButtonText);
            _controllers[key]!.text = '';
          }
        case EventCreationFormInputKeys.startTime:
          _controllers[key]!.text = eventTimeInitialText;
        case EventCreationFormInputKeys.endTime:
          _controllers[key]!.text = eventTimeInitialText;
        default:
          _controllers[key]!.text = '';
      }
    }
    Navigator.pop(context);
    scrollToTop(_scrollController);
  }

  Future<bool> _exitConfirmationDialog(BuildContext context) async {
    bool? shouldShowDialog = false;
    for (var key in EventCreationFormInputKeys.values) {
      if (validateTextField(_controllers[key]!.text) == null) {
        shouldShowDialog = true;
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
                  onWillPop(context);
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
    return onWillPop(context);
  }

  void _formValidation() async {
    final Map<EventCreationFormInputKeys, String> eventData = {};
    for (var key in EventCreationFormInputKeys.values) {
      final formField = _formFieldKeys[key];
      switch (key) {
        case EventCreationFormInputKeys.location:
        case EventCreationFormInputKeys.remoteLink:
          {
            final radioFormFieldState = formField!.currentState as RadioFormFieldState;
            radioFormFieldState.saveState();
            if (radioFormFieldState.selectedValue != null) {
              if (radioFormFieldState.selectedValue == otherRadioButtonText
                  && validateTextField(_controllers[key]!.text) == null) {
                eventData[key] = _controllers[key]!.text;
              } else {
                eventData[key] = radioFormFieldState.selectedValue!;
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
        default:
          eventData[key] = _controllers[key]!.text;
      }
    }
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    eventData[EventCreationFormInputKeys.email] = userEmail ?? "";
    EventCreationFormData data = EventCreationFormData.from(eventData);
    if (context.mounted) {
      EventCreationFormService(data).postEventFormData(
        context,
        (status) {
          setState(() {
            _isLoading = false;
          });
          if (status == 'SUCCESS') {
            Navigator.pushReplacementNamed(
              context,
              formSubmittedPagePath,
              arguments: FormResponseSubmittedPageArgument(
                formTitle: eventCreationFormHeaderText,
                formPath: eventCreationPagePath,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBar(content: const Text(errorFetching)),
            );
          }
        },
      );
    }
  }
}
