import 'getdisks.dart';
import 'tether.dart';

main() async {
  //setup usb disks
  var disks = await getDisks();
  disks.forEach((element) => print(element));
  var unmountedDisks = disks.where((e) {
    return !e.isMounted();
  }).toList();
  //mount usb
  if (unmountedDisks.length < 1) {
    return;
  }
  var mountedDisk = await unmountedDisks[0].mount('/mnt/usb');

  var disk2 = await getDisks();
  disk2.forEach((element) => print(element));
  //Handle tether to other raspberry pis
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
    //TODO: start video
  });
}
