import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

class FileManager {
  bool fileExist(String fileName) {
    return File(fileName).existsSync();
  }

  String readFileContent(String filepath) {
    final file = File(filepath);
    return file.readAsStringSync();
  }

  void createFile(String path, String content) {
    final file = File(path);
    final fileName = path.split('/').last;
    if (!fileExist(path)) {
      Logger().info(
        '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
      );
      file.writeAsString(content);
    } else {
      Logger().info(
        '''${styleBold.wrap('${lightYellow.wrap('File Exist $fileName SKIPED')}')}''',
      );
    }
  }
}
