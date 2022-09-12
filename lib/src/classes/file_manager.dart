import 'dart:io';

class FileManager {
  bool ifFileExist(String fileName) {
    return File(fileName).existsSync();
  }
}
