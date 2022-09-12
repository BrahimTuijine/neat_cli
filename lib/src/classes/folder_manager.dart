import 'dart:io';

class FolderManager {


  Future<void> createFolder(String path, Directory current) async {
    Directory.current = current;
    await Directory(path).create(recursive: true);
  }
}
