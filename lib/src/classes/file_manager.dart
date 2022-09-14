import 'dart:io';
class FileManager {
  bool fileExist(String fileName) {
    return File(fileName).existsSync();
  }

  String readFileContent(String filepath)  {
    final file = File(filepath);
    return file.readAsStringSync();
  }

  void createFile(String path, String content) {
    final file = File(path);
    if (!fileExist(path)) {
      file.writeAsString(content);
    }
  }
}
