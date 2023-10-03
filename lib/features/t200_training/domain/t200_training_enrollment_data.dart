class T200TrainingEnrollmentData {

  var courseName;
  var link;
  var totalTopics;
  var totalAssignments;
  var assignmentsCompleted;
  var averageScore;
  var courseProgress;
  var hasCompletedCourse;

  T200TrainingEnrollmentData(this.courseName,
                             this.link,
                             this.totalTopics,
                             this.totalAssignments,
                             this.assignmentsCompleted,
                             this.averageScore,
                             this.courseProgress,
                             this.hasCompletedCourse);

  T200TrainingEnrollmentData.from(Map<dynamic, dynamic> data) {
    courseName = data['courseName'];
    link = data['link'];
    totalTopics = data['totalTopics'];
    totalAssignments = data['totalAssignments'];
    assignmentsCompleted = data['assignmentsCompleted'];
    averageScore = data['averageScore'];
    courseProgress = data['courseProgress'];
    hasCompletedCourse = data['hasCompletedCourse'];
  }
}
