// This file is used to maintain strings at one place to easily modify

const String hostedDomain = 'rajasoftwarelabs.com';

/// common strings
const String appBarName = 'RSL - Back to School';
const String seeMoreButtonText = 'See More';
const String scrollToTopText = 'Scroll to Top';
const String resourcesText = 'Resources';
const String addFeedbackText = 'Add feedback';
const String errorFetching = 'Something went wrong. Please, try again later!';
const String continueDialogActionText = 'Continue';
const String oopsText = 'Oops!';
const String noInternetConnectionWarningText = 'Please check your network connection and try again.';
const String retryButtonText = 'Retry';
const String dismissButtonText = 'dismiss';

/// Footer
const String footerText = 'Raja Software Labs Confidential';

/// Fonts
const String interFont = 'Inter';

/// Sign in Page
const String signInHeader = 'Welcome to Back-to-School Portal';
const String signInSubHeader = 'Tickle the catalyst molecule of wonderment!';
const String signInButtonText = 'Sign in with RSL ID';
const String errorSignInRestricted = 'Sorry the app is restricted to RSL domain only';
const String errorSigningIn = 'Error occurred while signing in :';
const String errorUserNotFound = 'User not found error';
const String permissionsDialogTitle = 'Needs following permissions to continue';
const List<String> permissionsDialogContent = [
  '1. Google Drive permission to access RSL confidential docs.',
  '2. Personal information that you made public such as your name, profile picture and email address.',
];

/// Welcome section
const String welcomeSectionDescription =
    'Unlock your potential with our exceptional courses and '
    'training programs. Elevate your skills and knowledge '
    'for success in the dynamic world.';
const String welcomeLabel = 'Welcome';

// Exit home page

const String exitAppAlertTitleText = 'Are you sure?';
const String exitAppAlertContentText = 'Do you want to exit an App';
const String exitAppAlertNoText = 'No';
const String exitAppAlertYesText = 'Yes';

// Newsletter section

const String newsletterSectionHeader = 'Newsletters';
const String viewNewsletterButtonText = 'View Newsletter';
const String noNewslettersText = 'Stay tuned for newsletters';
String publishedOnText(String date) => 'Published on $date';

// Tech Series section

const String techSeriesHeader = 'Tech Series';
const String noTechSeriesText = 'Stay tuned for tech series events';

// Other Interesting Stuff section

const String otherInterestingStuffHeader = 'Other Interesting Stuff';
const String noOtherInterestingStuffText = 'Stay tuned for interesting stuff series';

// T200 Available Classes Section

const String t200AvailableClassesHeader = 'T200 Available Classes';
const String whatYouWillLearnText = 'What you\'ll learn';
const String viewJoinClassroomText = 'View/Join classroom';
const String noT200AvailableClassesText = 'Stay tuned for t200 classes';
const String manyMoreTopicsText = '+ Many more';

/// Platform Training Classes Section
const String platformTrainingClassesSectionHeader = 'Platform Training Classes';
const String noPlatformTrainingClassesText = 'Stay tuned for platform training classes';

// Backend Training

const String viewInClassroom = 'View in classroom';
const String classroomLink = 'https://classroom.google.com/c/';
const String comingSoon = 'Coming soon';
const String offeredCoursesHeaderText = 'Offered Courses';
const String yourEnrollmentsHeaderText = 'Your Enrollments';
const String noOfferedCoursesText = 'Stay tuned for offered courses';
const String noEnrolledCoursesText = 'There are no enrolled courses';
const String errorInReceivingEnrollmentsText =
    'Error in receiving enrollments.';

// Upcoming events section

const String upcomingEventsHeaderText = 'Upcoming Events';
const String noUpcomingEventsText = 'Stay tuned for upcoming events';
const String enrollmentSuccessText = 'Enrolled successfully';
const String enrollNowButtonText = 'Enroll Now';
const String enrolledButtonText = 'Enrolled';
const String joinHereButtonText = 'JOIN HERE';
const String remoteText = 'Remote';

// Upcoming/Ongoing Training section

const String upcomingOngoingTrainingHeaderText = 'Upcoming/Ongoing Training';
const String noUpcomingOngoingTrainingText = 'Stay tuned for upcoming/ongoing trainings';
const String topicsText = 'Topics:';

// Achievements section

const String achievementsHeaderText = 'Achievements';

// T200 Schedule section

const String t200ScheduleHeader = 'T200 Schedule';
const String whatYouWillLearnT200ScheduleText = 'What you\'ll learn';
const String traineeProgressDetailsHeaderText = "Trainee Progress Details";

// Your Enrollments section

const String yourEnrollmentsHeader = 'Your Enrollments';
const String ongoingText = 'Ongoing';
const String completedText = 'Completed';
const String viewInClassroomText = 'View in classroom';
const String emptyEnrollmentsText = 'It appears that you haven\'t enrolled for any courses';
String avgScoreText(String avgScore) => 'Average score: $avgScore';
String topicProgressText(int completedTopics, int totalTopics) =>
    '$completedText $completedTopics out of $totalTopics ${totalTopics > 1 ? "assignments" : "assignment"}';
String overallProgressText(String progress) => 'Progress: $progress%';
String progressText(String progress) => '$progress%';

// Overall Training Progress section

const String overallTrainingProgressHeader = 'Overall Training Progress';
const String searchByTraineeNameText = 'Search by trainee name';
const String selectPlatformOrResetText = 'Select platform/Reset';
const String androidPlatformText = 'Android';
const String webPlatformText = 'Web';
const String iOSPlatformText = 'iOS';
const String filterByTopicsText = 'Filter by total topics';
const String noEnrollmentsText = '<1 (No enrollments)';
const String enrolledAtLeastOnceText = '≥ 1 (Enrolled at least once)';
const String topicCompletedText = 'Topic completed';
const String topicsCompletedText = 'Topics completed';
const String leadNameText = 'Lead';
const String overallAvgScoreText = 'Average Score';
const String teamAvgScoreHeader = 'Team\'s Average Score';
const String teamTopPerformerText = 'Top Performer';
const String seeYourTeamStatText = 'See Your Team Stats';
const String yourTeamProgressText = 'Your Team\'s Progress';
const String showingDataForLabelText = 'Showing data for ';

// Common Form

const String formResponseRecordedText = 'Your response has been recorded.';
const String formSubmitAnotherResponseText = 'Submit another response.';
const String indicatesRequiredQuestionsText = '* Indicates required question';

// Tech Series Feedback Form

const String techSeriesFeedbackFormHeaderText = 'Tech Talk - Feedback';
const String techSeriesFeedbackFormDescriptionText = '''
Hi,

Thanks for attending / viewing the Tech Talk. We highly value your feedback and want to ensure the Tech Talks are tailored to meet your interests and expectations.

This questionnaire is designed to gather your feedback and suggestions on the Tech Talk that was conducted.

Your feedback will help us gauge the success of the Tech Talks and identify areas for improvement, ensuring that we deliver valuable content that aligns with your preferences.

Please fill out this quick form  (takes 2-3 mins) and let us know your thoughts.

Thank you.''';
const String techTalkTopicFieldText = 'Kindly choose the Tech Talk topic you wish to provide feedback on (Topic name should have been auto selected as per your selected topic on the Portal.';
const String chooseDropdownDefaultValue = 'Choose';
const String understandingFieldText = 'On a scale of 1 to 10, how well did you understand the content presented in the Tech Talk?';
const String understandingField1 = '1 (Not at all)';
const String understandingField5 = '5 (Moderately)';
const String understandingField10 = '10 (Extremely well)';
const String satisfiedFieldText = 'How satisfied were you with overall presentation: Slides, code demos, examples, talk, and questions handled in the Tech Talk?';
const String satisfiedField1Poor = '1 Poor, can be better';
const String satisfiedField10Excellent = '10 Excellent';
const String overallFieldText = 'Did you find the Tech Talk too technical / complex, just right, or not technical enough?';
const String overallFieldOption1 = 'Too technical, recommend to reduce complexity.';
const String overallFieldOption2 = 'Just right.';
const String overallFieldOption3 = 'Not technical enough, bring in more complex / deeper knowledge.';
const String logisticsFieldText = 'How would you rate the overall logistics: Audio / video quality, communication etc for the Tech Talk?';
const String logisticsFieldOption1 = 'Logistically all things were perfect.';
const String logisticsFieldOption2 = 'Audio quality can be improved.';
const String logisticsFieldOption3 = 'Video quality can be improved.';
const String logisticsFieldOption4 = 'Timings could be different.';
const String logisticsFieldOption5 = 'Zoom connectivity was flaky.';
const String durationFieldText = 'How was the duration of the talk?';
const String durationField1TooShort = '1 Too short';
const String durationField10TooLong = '10 Too long';
const String takeawayFieldText = 'What was your key takeaway from this Tech Talk?';
const String takeawayFieldOption1 = 'Practical Strategies: Actionable tips and techniques you can use right away to enhance your project work efficiency and productivity.';
const String takeawayFieldOption2 = 'In-depth Technical Insights: A deeper understanding of the technical concepts covered, helping you build a stronger foundation in the subject.';
const String takeawayFieldOption3 = 'Fresh Perspectives: New ideas and perspectives that challenged your thinking and offered innovative approaches to problem-solving.';
const String takeawayFieldOption4 = 'Applicable Knowledge: Knowledge that you can directly apply to your projects, empowering you to create impactful solutions.';
const String followUpFieldText = 'Would you like to see follow-up talks on the same topic in the future?';
const String followUpFieldOption1 = 'Yes, I\'m interested in exploring the topic in greater depth and expanding my knowledge, will definitely attend next talk whenever it is planned.';
const String followUpFieldOption2 = 'Yes, but with more hands-on demos: I would like more practical demonstrations and hands-on sessions related to this topic.';
const String followUpFieldOption3 = 'Yes, but with deeper level content and knowledge of internals.';
const String followUpFieldOption4 = 'No';
const String recommendFieldText = 'How likely are you to recommend this Tech Talk to other folks in the company?';
const String recommendFieldOption1 = 'Highly Recommend: I would highly recommend this Tech Talk to other folks.';
const String recommendFieldOption2 = 'Recommend: I see value in the Tech Talk and would recommend it to some folks.';
const String recommendFieldOption3 = 'Not at this time: Currently not considering it.';
const String recommendFieldOption4 = 'No: This Tech Talk is not relevant to many folks in the company, so will not recommend it.';
const String particularFeedbackFieldText = 'Is there any particular feedback you want to convey to the author of the Tech Talk?';
const String otherTopicsFieldText = 'What other topics or areas would you like to see covered in future Tech Talks (it is okay if the topic suggested is not relevant to current Tech Talk)?';
const String suggestionFieldText = 'Any additional comments or suggestion from your end';

// Events Creation Form

const String eventCreationFormHeaderText = 'Request for Event Creation';
const String eventCreationFormDescriptionText = '''
Welcome to the Event Creation Form! Please provide the necessary details below to request the addition of your event to the calendar and have it featured in the "Upcoming Events" section on our portal's home page.

Note: All fields marked with (*) are required.

We are excited to help you promote your event and engage all the employees. Once you submit the form, our team will review your request. If approved, your event will be added to the calendar and showcased on our portal. You will receive an email for the confirmation as well. 

Thanks for your contribution!!''';
const yourAnswerFormHintText = 'Your answer';
const otherRadioButtonText = 'Other:';
const googleMeetRadioButtonText = 'Google Meet';
const remoteRadioButtonText = 'Remote';
const eventTitleText = 'Event title';
const eventDescriptionText = 'Event description';
const eventLocationText = 'Where will the event be hosted?';
const eventDateText = 'What is the date of the event?';
const eventDateInitialText = 'mm/dd/yyyy';
const eventTimeInitialText = '__:__ AM';
const eventStartTimeText = 'What is the start time of the event?';
const eventEndTimeText = 'What is the end time of the event?';
const eventRemoteLinkText = 'Please provide the remote meeting link for the event if it will be hosted on a platform other than Google Meet. If the event will be hosted on Google Meet, please select the corresponding option.';
const submitButtonText = 'Submit';
const clearFormButtonText = 'Clear form';
const clearFormDialogTitleText = 'Clear Form?';
const clearFormDialogContentText = 'This will remove your answers from all questions, and cannot be undone.';
const cancelDialogActionText = 'Cancel';
const alertAreYouSureTitleText = 'Are you sure?';
const yesDialogActionText = 'Yes';
const noDialogActionText = 'No';
const requiredText = '*';
const requiredErrorText = 'This is a required question';
const timeErrorInvalidText = 'Enter date in valid range';
const dateDialogFormatText = 'Enter valid date';
const dateDialogFieldLabelText = 'Event date';
const dateDialogErrorInvalidText = 'Enter date in valid range';

// T200 Statistics

const t200StatisticsHeader = 'T200 Statistics';

// Feedback Form

const String feedbackFormHeaderText = 'Back to School Portal - Feedback';
const String feedbackFormDescriptionText = '''
Thank you for using "Back to School" Portal and accessing the various features and resources available on Portal. We value your feedback and suggestions to enhance your experience and make the portal more valuable for all employees. Please take a few minutes to complete this feedback form and share your thoughts with us.

Your input will help us understand what is working well, what can be improved, and what additional features you would like to see in further releases.

Instructions:

- Please answer the questions to the best of your ability based on your experience using the portal.
- Feel free to provide specific examples or additional comments.

Thank you for your participation and valuable feedback!''';
const featuresWithGoodInsightsFieldText = 'Which features are providing good insights and have been helpful to you from the portal?';
const trainingOrCoursesFieldText = 'Are there any specific training programs or courses you found particularly helpful or engaging? If yes, please specify.';
const upcomingFeaturesFieldText = 'What features you would like to see on this portal in the upcoming releases?';
const difficultiesFieldText = 'Are there any difficulties or challenges you encountered while using the portal? If yes, please describe.';
const otherSuggestionsFieldText = 'Do you have any other suggestions or feedback to help us improve the portal and make it more valuable for you?';
