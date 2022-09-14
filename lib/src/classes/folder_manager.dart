import 'dart:io';

class FolderManager {


  void createFolder(String path, Directory current) {
    Directory.current = current;
    Directory(path).createSync(recursive: true);
  }
}
