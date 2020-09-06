import 'getdisks.dart';
import 'tether.dart';

main() async {
  //setup usb disks
  var disks = await getDisks();
  disks.forEach((element) => print(element));
  Disk mountedDisk = null;
  while (mountedDisk == null) {
    mountedDisk = disks.firstWhere(
        (element) => element.mountpoint == '/mnt/usb',
        orElse: () => null);

    if (mountedDisk == null) {
      mountedDisk = await getUsb(disks);
    }
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
