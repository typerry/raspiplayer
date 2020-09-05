import 'dart:io';
import 'dart:convert';

class Disk {
  final String uuid;
  final String fstype;
  final String mountpoint;
  Disk(this.uuid, this.fstype, this.mountpoint);

  @override
  String toString() {
    return 'uuid : $uuid fstype : $fstype mountpoint : $mountpoint';
  }

  bool isMounted() {
    return mountpoint != '';
  }

  Future<int> mount(String path) async {
    if (!isMounted()) {
      ProcessResult results =
          await Process.run('mount', ['--uuid', uuid, path]);
      return Future<int>(() => results.exitCode);
    }
    return Future<int>(() => 1);
  }
}

Future<List<Disk>> getDisks() async {
  List<Disk> disks = new List<Disk>();

  //lsblk -o UUID,FSTYPE,MOUNTPOINT
  //Process.run('ls', ['-l']).then((ProcessResult results) {
  ProcessResult results =
      await Process.run('lsblk', ['-o', 'UUID,FSTYPE,MOUNTPOINT']);

  String s = results.stdout as String;
  //print(s);
  s = s.replaceAll(RegExp(' +'), ' ');
  var lines = LineSplitter().convert(s);
  lines.removeWhere((e) => e.contains('UUID'));

  lines.forEach((e) {
    e = e.trim();
    if (e == '') {
      return;
    }
    var ds = e.split(' ');
    var mp = ds.length == 3 ? ds[2] : '';
    var disk = Disk(ds[0], ds[1], mp);
    disks.add(disk);
  });

  return new Future(() => disks);
}
