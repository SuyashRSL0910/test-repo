import 'package:firebase_database/firebase_database.dart';

import '../domain/backend_training_data.dart';
import 'database_keys.dart';

class BackendTrainingRepository {
  late DatabaseReference _classroomDatabaseReference;

  BackendTrainingRepository() {
    _classroomDatabaseReference = FirebaseDatabase.instance.ref(
        classroomDatabaseKey);
  }

  Future<List<BackendTrainingData>> getBackendTrainingData() async {
    List<BackendTrainingData> modelList = [];
    final DatabaseReference backendTrainingDatabase =
    _classroomDatabaseReference.child(backendTrainingKey);
    final snapshot = await backendTrainingDatabase.get();
    if (snapshot.exists) {
      List<dynamic> backendTrainingsList =
      List<dynamic>.from(snapshot.value as List);
      for (int i = 0; i < backendTrainingsList.length; i++) {
        modelList.add(BackendTrainingData.from(backendTrainingsList[i]));
      }
    }

    return modelList;
  }
}
