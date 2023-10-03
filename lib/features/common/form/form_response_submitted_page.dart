import 'package:flutter/material.dart';
import 'package:home_page/core/arguments/form_response_submitted_page_argument.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/core/utils/dart_utils.dart';
import 'package:home_page/drawer/presentation/drawer_menu_page.dart';

const _widthForLandscapeMode = 400.0;

class FormResponseSubmittedPage extends StatelessWidget {
  const FormResponseSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortraitOrientation = isPortraitMode(context);
    final argument = ModalRoute.of(context)!.settings.arguments as FormResponseSubmittedPageArgument;
    final formTitle = argument.formTitle;
    final formPath = argument.formPath;
    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarName),
      ),
      drawer: const DrawerMenuPage(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(cardPadding),
          child: Center(
            child: SizedBox(
              width: isPortraitOrientation ? null : _widthForLandscapeMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(formCardRadius),
                      side: BorderSide(
                        color: cardLightBorderColor!,
                        width: 1,
                      ),
                    ),
                    child: Column(
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
                              sectionHeader(formTitle, context: context),
                              verticalSpace(height: sectionHeaderSpacingHeight),
                              Text(
                                formResponseRecordedText,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              verticalSpace(height: sectionSpacingHeight),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    formPath,
                                  );
                                },
                                child: Text(
                                  formSubmitAnotherResponseText,
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.blue.shade600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
