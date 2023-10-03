import 'package:flutter/material.dart';
import 'package:home_page/core/constants/colors.dart';
import 'package:home_page/core/constants/dimen.dart';
import 'package:home_page/core/constants/strings.dart';
import 'package:home_page/core/utils/common_widgets.dart';
import 'package:home_page/features/t200_training/domain/training_progress_data.dart';
import 'package:home_page/features/t200_training/presentation/components/overall_progress_details_components/trainee_progress_details_page.dart';
import 'package:home_page/features/t200_training/presentation/components/training_progress_section.dart';

class OverallTrainingProgressSection extends StatefulWidget {

  final List<TraineeProgressData> traineeProgressDataModels;

  const OverallTrainingProgressSection({super.key, required this.traineeProgressDataModels});

  @override
  State<OverallTrainingProgressSection> createState() => _OverallTrainingProgressSectionState();
}

class _OverallTrainingProgressSectionState extends State<OverallTrainingProgressSection> {

  final controller = TextEditingController();
  final focusNode = FocusNode();

  List<TraineeProgressData> suggestedTraineeProgressData = [];
  List<TraineeProgressData> allTraineeProgressData = [];
  List<TraineeProgressData> traineeProgressDataModels = [];

  List<String> platformList = <String>[
    selectPlatformOrResetText,
    androidPlatformText,
    iOSPlatformText,
    webPlatformText,
  ];
  List<String> filterTopicOptions = <String>[
    filterByTopicsText,
    noEnrollmentsText,
    enrolledAtLeastOnceText
  ];

  String? platformValue;
  String? filterTopicValue;

  double defaultContainerHeight = 275;
  double defaultTeamMembersContainerHeight = 280;
  late double currentContainerHeight;
  late double teamMembersContainerHeight;
  late double traineeSuggestionsHeight;

  ScrollController? respectiveTeamMembersController;
  ScrollController? traineeSuggestionsController;

  @override
  void initState() {
    super.initState();

    platformValue = platformList[0];
    filterTopicValue = filterTopicOptions[0];

    suggestedTraineeProgressData = widget.traineeProgressDataModels;
    allTraineeProgressData = widget.traineeProgressDataModels;
    traineeProgressDataModels = widget.traineeProgressDataModels;

    traineeSuggestionsHeight = 0;
    respectiveTeamMembersController = ScrollController();
    traineeSuggestionsController = ScrollController();

    _setTeamMembersContainerHeight();
    controller.addListener(_onTextValueChanged);
  }

  @override
  void dispose() {
    controller.clear();
    traineeSuggestionsController!.dispose();
    respectiveTeamMembersController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sectionHeader(overallTrainingProgressHeader, context: context, addTextDecoration: true),
        verticalSpace(height: sectionHeaderSpacingHeight),
        _getSearchBar(),
        _getTraineeSuggestions(),
        _getPlatformFilterDropdown(),
        _getTopicFilterDropdown(),
        _showRespectiveTeamMembers(),
      ],
    );
  }

  Widget _getSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.grey,
          hintText: searchByTraineeNameText,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onTapOutside: (_) {
          focusNode.unfocus();
        },
      ),
    );
  }

  Widget _getTraineeSuggestions() {
    return Visibility(
      visible: suggestedTraineeProgressData.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SizedBox(
          height: traineeSuggestionsHeight,
          child: Scrollbar(
            thickness: 10,
            thumbVisibility: true,
            interactive: true,
            controller: traineeSuggestionsController,
            child: ListView.builder(
              controller: traineeSuggestionsController,
              itemCount: suggestedTraineeProgressData.length,
              itemBuilder: (context, index) {
                if (suggestedTraineeProgressData.isNotEmpty) {
                  final traineeProgress = suggestedTraineeProgressData[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListTile(
                      title: Text(traineeProgress.traineeName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1),
                      onTap: () {
                        setState(() {
                            controller.text = traineeProgress.traineeName;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TraineeProgressDetails(
                                    trainee: traineeProgress),),
                            ).then((_) {
                                setState(() {
                                    suggestedTraineeProgressData = [];
                                    controller.text = '';
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPlatformFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 36,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            hint: Text(
              platformList[0],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: platformValue == platformList[0] ? null : platformValue,
            onChanged: (newValue) {
              setState(
                () {
                  suggestedTraineeProgressData = [];
                  platformValue = newValue.toString();
                  allTraineeProgressData = _getListOfFilteredTrainees();
                  _setTeamMembersContainerHeight();
                },
              );
            },
            items: platformList.map<DropdownMenuItem<String>>(
              (String valueItem) {
                return DropdownMenuItem<String>(
                  value: valueItem,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      valueItem,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _getTopicFilterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButton(
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 36,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            hint: Text(
              filterTopicOptions[0],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: filterTopicValue ==  filterTopicOptions[0] ? null : filterTopicValue,
            onChanged: (newValue) {
              setState(
                () {
                  suggestedTraineeProgressData = [];
                  filterTopicValue = newValue.toString();
                  allTraineeProgressData = _getListOfFilteredTrainees();
                  _setTeamMembersContainerHeight();
                },
              );
            },
            items: filterTopicOptions.map<DropdownMenuItem<String>>(
              (String valueItem) {
                return DropdownMenuItem<String>(
                  value: valueItem,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      valueItem,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  Widget _showRespectiveTeamMembers() {
    return Visibility(
      visible: teamMembersContainerHeight > 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: SizedBox(
          height: teamMembersContainerHeight,
          child: Card(
            shape: cardBorder(),
            elevation: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cardRadius),
              child: Scrollbar(
                thickness: 10,
                thumbVisibility: true,
                interactive: true,
                controller: respectiveTeamMembersController,
                child: ListView.builder(
                  controller: respectiveTeamMembersController,
                  itemCount: allTraineeProgressData.length,
                  itemBuilder: (context, index) {
                    if (allTraineeProgressData.isNotEmpty) {
                      final traineeProgress = allTraineeProgressData[index];
                      Icon icon = getIconFromPlatformName(traineeProgress.platform);
                      return Padding(
                        padding: EdgeInsets.only(
                            top: (index == 0 ? 10 : 5),
                            bottom: (index == allTraineeProgressData.length - 1 ? 10 : 5),
                            left: 10,
                            right: 10),
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                          ),
                          child: ListTile(
                            title: Text(traineeProgress.traineeName,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1),
                            trailing: icon,
                            leading: const VerticalDivider(
                              color: appThemeColor,
                              thickness: 2,
                              endIndent: 5,
                            ),
                            onTap: () {
                              setState(() {
                                  controller.text = traineeProgress.traineeName;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TraineeProgressDetails(
                                          trainee: traineeProgress),
                                    ),
                                  ).then((_) {
                                      setState(() {
                                          controller.text = '';
                                          suggestedTraineeProgressData = [];
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setTeamMembersContainerHeight() {
    if (allTraineeProgressData.isEmpty) {
      teamMembersContainerHeight = 0;
    } else if (allTraineeProgressData.length < 5) {
      teamMembersContainerHeight = allTraineeProgressData.length * 60;
    } else {
      teamMembersContainerHeight = defaultTeamMembersContainerHeight;
    }
    currentContainerHeight = defaultContainerHeight + teamMembersContainerHeight;
  }

  List<TraineeProgressData> _getListOfFilteredTrainees() {
    var listOfFilteredTrainees = <TraineeProgressData>[];
    traineeProgressDataModels.asMap().forEach((index, value) {
      if (platformValue != platformList[0] &&
          filterTopicValue != filterTopicOptions[0]) {
        if (filterTopicValue == filterTopicOptions[2]) {
          if (traineeProgressDataModels[index].platform ==
              platformValue &&
              traineeProgressDataModels[index].topics.isNotEmpty) {
            listOfFilteredTrainees.add(traineeProgressDataModels[index]);
          }
        } else if (filterTopicValue == filterTopicOptions[1]) {
          if (traineeProgressDataModels[index].platform == platformValue
              && traineeProgressDataModels[index].topics.isEmpty) {
            listOfFilteredTrainees.add(traineeProgressDataModels[index]);
          }
        }
      } else if (platformValue != platformList[0] &&
          filterTopicValue == filterTopicOptions[0]) {
        if (traineeProgressDataModels[index].platform == platformValue) {
          listOfFilteredTrainees.add(traineeProgressDataModels[index]);
        }
      } else if (platformValue == platformList[0] &&
          filterTopicValue != filterTopicOptions[0]) {
        if (filterTopicValue == filterTopicOptions[2]) {
          if (traineeProgressDataModels[index].topics.isNotEmpty) {
            listOfFilteredTrainees.add(traineeProgressDataModels[index]);
          }
        } else if (filterTopicValue == filterTopicOptions[1]) {
          if (traineeProgressDataModels[index].topics.isEmpty) {
            listOfFilteredTrainees.add(traineeProgressDataModels[index]);
          }
        }
      } else {
        listOfFilteredTrainees.add(traineeProgressDataModels[index]);
      }
    });
    return listOfFilteredTrainees;
  }

  void _onTextValueChanged() {
    if (controller.text.isNotEmpty) {
      final suggestions = allTraineeProgressData.where((traineeProgress) {
        final traineeName = traineeProgress.traineeName.toLowerCase();
        final input = controller.text.toLowerCase();

        return traineeName.contains(input);
      }).toList();

      setState(() {
        suggestedTraineeProgressData = suggestions;
        if (suggestedTraineeProgressData.isNotEmpty) {
          if (suggestedTraineeProgressData.length < 5) {
            traineeSuggestionsHeight = suggestedTraineeProgressData.length * 70;
          } else {
            traineeSuggestionsHeight = 4 * 70;
          }
          currentContainerHeight += traineeSuggestionsHeight;
        } else {
          _setTeamMembersContainerHeight();
        }
      });
    } else {
      setState(() {
        _setTeamMembersContainerHeight();
        suggestedTraineeProgressData = [];
      });
    }
  }
}
