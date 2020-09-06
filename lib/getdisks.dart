import 'dart:io';
import 'dart:convert';

class Disk {
  final String uuid;
  final String fstype;
  //final String mountpointUri;
  final Directory mountpoint;

  Disk(this.uuid, this.fstype, String mountpointUri)
      : this.mountpoint = new Directory(mountpointUri);

  @override
  String toString() {
    return 'uuid : $uuid fstype : $fstype mountpoint : ${mountpoint.path}';
  }

  bool isMounted() {
    return mountpoint.path != '';
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

Future<Disk> getUsb(List<Disk> disks) async {
  var unmountedDisks = disks.where((e) {
    return !e.isMounted();
  }).toList();
  //mount usb
  if (unmountedDisks.length < 1) {
    return null;
  }
  await unmountedDisks[0].mount('/mnt/usb');

  var disks2 = await getDisks();
  return Future<Disk>(() => disks2.firstWhere(
        (element) => element.mountpoint.path == '/mnt/usb',
        orElse: () => null,
      ));
}
