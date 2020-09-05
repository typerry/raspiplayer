import 'getdisks.dart';
import 'tether.dart';

main() async {
  //setup usb disks
  var disks = await getDisks();
  disks.forEach((element) => print(element));
  var unmountedDisks = disks.where((e) {
    return !e.isMounted();
  });
  print('unmounted...');
  unmountedDisks.forEach((element) => print(element));

  //TODO: mount usb, find video

  //Handle tether to other raspberry pis
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
    //TODO: start video
  });
}
