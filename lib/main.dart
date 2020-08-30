import 'dart:convert';

import 'tether.dart';
import 'dart:io';

main() async {
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
  });

  //lsblk -o UUID,FSTYPE,MOUNTPOINT
  //Process.run('ls', ['-l']).then((ProcessResult results) {
  Process.run('lsblk', ['-o', 'UUID,FSTYPE,MOUNTPOINT'])
      .then((ProcessResult results) {
    String s = results.stdout as String;
    s = s.replaceAll(RegExp(' +'), ' ');
    var lines = LineSplitter().convert(s);
    lines.removeWhere((e) => e.contains('UUID'));
    lines.forEach((e) {
      print('line: $e');
      var ds = s.split(' ');
      ds.forEach(print);
    });
  });
}
