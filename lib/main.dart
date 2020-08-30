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
    print(s);
    s = s.replaceAll(RegExp(' +'), ' ');
    var lines = LineSplitter().convert(s);
    lines.removeWhere((e) => e.contains('UUID'));
    lines.forEach((e) {
      //print('line: $e');
      var ds = e.split(' ');
      var mp = ds.length == 3 ? ds[2] : '';
      var disk = Disk(ds[0], ds[1], mp);
      print(disk.toString());
      // ds.forEach((e2) {
      //   print('part: $e2');
      // });
    });
  });
}

class Disk {
  final String uuid;
  final String fstype;
  final String mountpoint;
  Disk(this.uuid, this.fstype, this.mountpoint);

  @override
  String toString() {
    return 'uuid : $uuid fstype : $fstype mountpoint : $mountpoint';
  }
}
