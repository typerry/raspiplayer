import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

class Tether {
  Tether._create(RawDatagramSocket socket, void Function() callback) {
    var connections = List<int>();

    _listen(socket, (int id) {
      if (!connections.contains(id)) {
        connections.add(id);
        callback();
      }
    });

    var id = Uint8List(4)..buffer.asInt32List()[0] = Random().nextInt(1 << 32);

    _send(socket, id);
  }

  /// Public factory
  static Future<Tether> create(void Function() callback) async {
    return Future<Tether>(() async {
      var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 6790);
      socket.broadcastEnabled = true;
      return Tether._create(socket, callback);
    });
  }

  _send(RawDatagramSocket socket, Uint8List id) async {
    while (true) {
      socket.send(id, InternetAddress('255.255.255.255'), 6790);
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  _listen(RawDatagramSocket socket, void Function(int id) callback) async {
    while (true) {
      var r = await _recv(socket);
      var id = r.data.buffer.asInt32List()[0];
      callback(id);
    }
  }

  Future<Datagram> _recv(RawDatagramSocket socket) async {
    return Future<Datagram>(() async {
      while (true) {
        var r = socket.receive();
        if (r != null) {
          return (r);
        } else {
          await Future.delayed(const Duration(milliseconds: 16));
        }
      }
    });
  }
}
