import 'package:flutter/material.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'dart_utils.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.child,
    required this.loader,
    required this.emptyStateMessage,
    required this.errorReload,
  });

  final Future<T> future;
  final Widget loader;
  final Function errorReload;
  final String emptyStateMessage;
  final Widget Function(T data) child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return loader;
          case ConnectionState.done:
            if (snapshot.hasError) {
              debugPrint(
                'Error occurred while fetching $T : ${snapshot.error}',
              );
              return errorState(refresh: errorReload);
            } else if (snapshot.hasData && _isDataNotNull(snapshot.requireData)) {
              return child(snapshot.requireData);
            }
          default:
            debugPrint('Connection state: ${snapshot.connectionState}');
        }
        // Should be unreachable but still show empty state instead of
        // showing any error.
        return emptyState(emptyStateMessage: emptyStateMessage);
      },
    );
  }
}

bool _isDataNotNull(dynamic data) {
  if (data is List) {
    return isListNotNull(data);
  } else if (data is Map) {
    return isMapNotNull(data);
  } else if (data != null) {
    return true;
  }

  return false;
}
