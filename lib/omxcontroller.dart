import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

playFile(File file) async {
  var exists = await file.exists();
  if (exists) {
    await Process.run('omxplayer', ['-p', '-o', 'hdmi', file.path]);
  }
}

bool checkExtension(File file) {
  var extension = p.extension(file.path);
  return (extension != 'mp4');
}
