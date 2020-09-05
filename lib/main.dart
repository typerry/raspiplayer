import 'getdisks.dart';
import 'tether.dart';

main() async {
  //setup usb disks
  var disks = await getDisks();
  disks.forEach((element) => print(element));
  Disk mountedDisk =
      disks.firstWhere((element) => element.mountpoint == '/mnt/usb');

  if (mountedDisk == null) {
    var unmountedDisks = disks.where((e) {
      return !e.isMounted();
    }).toList();
    //mount usb
    if (unmountedDisks.length < 1) {
      return;
    }
    await unmountedDisks[0].mount('/mnt/usb');

    var disks2 = await getDisks();
    disks2.forEach((element) => print(element));
    mountedDisk =
        disks2.firstWhere((element) => element.mountpoint == '/mnt/usb');
  }

  if (mountedDisk == null) {
    print('no usable disk found...');
    return;
  }
  print('------');
  print(mountedDisk.toString());

  //Handle tether to other raspberry pis
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
    //TODO: start video
  });
}
