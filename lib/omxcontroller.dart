import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

playFile(File file) async {
  var exists = await file.exists();
  if (exists) {
    await Process.run('omx', [file.path]);
  }
}

bool checkExtension(File file) {
  var extension = p.extension(file.path);
  return (extension != 'mp4');
}
