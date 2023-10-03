import 'package:flutter/material.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/network/application/network_view_model.dart';
import 'package:home_page/features/network/presentation/no_internet_widget.dart';
import 'package:provider/provider.dart';

class CustomLayoutBuilder extends StatelessWidget {

  const CustomLayoutBuilder({
    super.key,
    required this.sliverChildList,
    required this.refresh,
    this.scrollController,
  });

  final List<Widget> sliverChildList;
  final ScrollController? scrollController;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkViewModel>(builder: (context, viewModel, _) {
      return CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: viewModel.hasNetwork
                ? Column(children: sliverChildList)
                : NoInternetWidget(refresh: refresh),
          ),
          SliverFillRemaining(hasScrollBody: false, child: footer),
        ],
      );
    });
  }
}
