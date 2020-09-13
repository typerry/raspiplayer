import 'getdisks.dart';
import 'tether.dart';
import 'dart:io';
import 'omxcontroller.dart';

main() async {
  //setup usb disks
  Disk mountedDisk = null;
  while (mountedDisk == null) {
    var disks = await getDisks();
    mountedDisk = disks.firstWhere(
        (element) => element.mountpoint.path == '/mnt/usb',
        orElse: () => null);

    if (mountedDisk == null) {
      mountedDisk = await getUsb(disks);
    }
  }

  print('------');
  print(mountedDisk.toString());
  print('------');

  List<File> files = List<File>();
  mountedDisk.mountpoint.listSync().forEach((element) {
    print(element.path);
    if (element is File) {
      if (checkExtension(element)) {
        files.add(element);
        print(element.path);
      }
    }
  });
  if (files.length == 0) {
    print('no files found!');
  }
  print('------');

  //Handle tether to other raspberry pis
  int count = 0;
  List<Process> omx = List<Process>();
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
    //TODO: start video
    playFile(files[0]).then((value) {
      omx.forEach((element) {
        element.kill(ProcessSignal.sigterm);
      });

      omx.add(value);
    });
  });
}
