import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<Process> playFile(File file) async {
  var exists = await file.exists();
  if (exists) {
    return Process.start('omxplayer', ['-p', '-o', 'hdmi', file.path]);
  }
  return null;
}

bool checkExtension(File file) {
  var extension = p.extension(file.path);
  return (extension != 'mp4');
}
