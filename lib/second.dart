import 'getdisks.dart';
import 'tether.dart';
import 'dart:io';
import 'omxcontroller.dart';

main() async {
  //Handle tether to other raspberry pis
  int count = 0;
  var t = await Tether.create(() {
    count++;
    print('called');
  });
}
