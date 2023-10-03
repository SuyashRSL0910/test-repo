import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/form_response_submitted_page_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';
import 'package:home_page/features/common/form/common_form_widgets.dart';
import 'package:home_page/features/common/layout/custom_layout_builder.dart';
import 'package:home_page/features/feedback/application/feedback_form_service.dart';
import 'package:home_page/features/feedback/domain/feedback_form_data.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final Map<FeedbackFormInputKeys, TextEditingController> _controllers = {};
  final Map<FeedbackFormInputKeys, FocusNode> _focusNodes = {};
  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    for (var e in FeedbackFormInputKeys.values) {
      const String initialText = '';
      _controllers[e] = TextEditingController(text: initialText);
      _focusNodes[e] = FocusNode();
    }
  }

  @override
  void dispose() {
    _controllers.values.map((e) => e.dispose());
    _focusNodes.values.map((e) => e.dispose());
    _controllers.clear();
    _focusNodes.clear();
    _scrollController.dispose();
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
                        headerText: feedbackFormHeaderText,
                        bodyText: feedbackFormDescriptionText,
                        context: context,
                      ),
                      verticalSpace(height: sectionSpacingHeight),
                      _formInputCards(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                      ),
                      verticalSpace(height: sectionHeaderSpacingHeight),
                      formButtons(
                        context: context,
                        submitForm: _submitForm,
                        clearForm: _clearForm,
                        isLoading: _loading,
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
    required Map<FeedbackFormInputKeys, TextEditingController> controllers,
    required Map<FeedbackFormInputKeys, FocusNode> focusNodes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFormFieldWithLabel(
          labelText: featuresWithGoodInsightsFieldText,
          focusNode: focusNodes[FeedbackFormInputKeys.featuresWithGoodInsights],
          controller: controllers[FeedbackFormInputKeys.featuresWithGoodInsights],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          labelText: trainingOrCoursesFieldText,
          focusNode: focusNodes[FeedbackFormInputKeys.trainingOrCourses],
          controller: controllers[FeedbackFormInputKeys.trainingOrCourses],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          labelText: upcomingFeaturesFieldText,
          focusNode: focusNodes[FeedbackFormInputKeys.upcomingFeatures],
          controller: controllers[FeedbackFormInputKeys.upcomingFeatures],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          labelText: difficultiesFieldText,
          focusNode: focusNodes[FeedbackFormInputKeys.difficulties],
          controller: controllers[FeedbackFormInputKeys.difficulties],
          context: context,
        ),
        verticalSpace(),
        textFormFieldWithLabel(
          labelText: otherSuggestionsFieldText,
          focusNode: focusNodes[FeedbackFormInputKeys.otherSuggestions],
          controller: controllers[FeedbackFormInputKeys.otherSuggestions],
          context: context,
        ),
      ],
    );
  }

  void _submitForm() async {
    setState(() {
      _loading = true;
    });
    final Map<FeedbackFormInputKeys, String> feedbackData = {};
    for (var key in FeedbackFormInputKeys.values) {
      feedbackData[key] = _controllers[key]!.text;
    }

    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    feedbackData[FeedbackFormInputKeys.email] = userEmail ?? "";
    FeedbackFormData data = FeedbackFormData.from(feedbackData);
    FeedbackFormService(data).postFeedbackFormData(
      context,
      (status) {
        setState(() {
          _loading = false;
        });
        if (status == 'SUCCESS') {
          Navigator.pushReplacementNamed(
            context,
            formSubmittedPagePath,
            arguments: FormResponseSubmittedPageArgument(
              formTitle: feedbackFormHeaderText,
              formPath: feedbackPagePath,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(errorFetching)),
          );
        }
      },
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    for (var key in FeedbackFormInputKeys.values) {
      _controllers[key]!.text = '';
    }
    Navigator.pop(context);
    scrollToTop(_scrollController);
  }

  Future<bool> _exitConfirmationDialog(BuildContext context) async {
    bool? shouldShowDialog = false;
    for (var e in FeedbackFormInputKeys.values) {
      if (validateTextField(_controllers[e]!.text) == null) {
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
}
