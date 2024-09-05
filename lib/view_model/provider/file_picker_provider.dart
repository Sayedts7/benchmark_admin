import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerProvider with ChangeNotifier {
  List<PlatformFile> _webFiles = [];
  List<PlatformFile> get webFiles => _webFiles;

  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      if (kIsWeb) {
        _webFiles = result.files;
      }
      notifyListeners();
    }
  }

  void removeWebFile(PlatformFile file) {
    _webFiles.remove(file);
    notifyListeners();
  }

  void clearAll() {
    _webFiles.clear();
    notifyListeners();
  }

  Future<List<Map<String, String>>> uploadFiles(String projectId) async {
    List<Map<String, String>> fileUrls = [];

    if (_webFiles.isNotEmpty) {
      try {
        int totalFiles = _webFiles.length;
        int uploadedFiles = 0;

        var randomId = DateTime.now().millisecondsSinceEpoch.toString();

        for (var file in _webFiles) {
          String fileName = file.name;
          var ref = FirebaseStorage.instance.ref().child('adminFiles/$randomId/$fileName');
          UploadTask uploadTask = ref.putData(file.bytes!);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            uploadProgress.value = progress;
          });

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          fileUrls.add({
            'name': fileName,
            'url': downloadUrl,
          });

          uploadedFiles++;
          uploadProgress.value = (uploadedFiles / totalFiles) * 100;
        }

        // Update Firestore with the new file URLs
        await FirebaseFirestore.instance.collection('Projects').doc(projectId).update({
          'adminFileUrls': fileUrls,
          // Add other fields you want to update
        });

        return fileUrls;
      } catch (error) {
        print('Error uploading files: $error');
        rethrow;
      }
    }
    return [];
  }
}