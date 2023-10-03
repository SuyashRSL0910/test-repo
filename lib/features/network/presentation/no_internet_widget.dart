import 'package:flutter/material.dart';
import 'package:home_page/core/constants/constants.dart';
import 'package:home_page/core/utils/common_widgets.dart';

class NoInternetWidget extends StatefulWidget {
  const NoInternetWidget({super.key, required this.refresh});

  final Function refresh;

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(cardContentPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '${resourcePath}no_internet_connection.png',
                          fit: BoxFit.fill,
                        ),
                        sectionHeader(oopsText, context: context),
                        verticalSpace(),
                        sectionBody(
                          noInternetConnectionWarningText,
                          context: context,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpace(),
                        OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                widget.refresh();
                              },
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: const Text(retryButtonText),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
