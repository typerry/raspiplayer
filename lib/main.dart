import 'tether.dart';

main() async {
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('resetting video! : $count');
  });
}
