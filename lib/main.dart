import 'package:raspiplayer/getdisks.dart';

import 'tether.dart';

main() async {
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
  });

  getDisks().then((value) => {value.forEach((element) => print(element))});
}
