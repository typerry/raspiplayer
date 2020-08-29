import 'dart:io';

class Tether {
  Tether._create(RawDatagramSocket socket, InternetAddress address,
      void Function() callback) {
    var connections = List<InternetAddress>();

    _listen(socket, (InternetAddress message) {
      if (!connections.contains(message)) {
        connections.add(message);
        callback();
      }
    });

    _send(socket, address);
  }

  /// Public factory
  static Future<Tether> create(void Function() callback) async {
    return Future<Tether>(() async {
      var dd = await NetworkInterface.list();
      var socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 6790);
      socket.broadcastEnabled = true;
      return Tether._create(socket, dd[0].addresses[0], callback);
    });
  }

  _send(RawDatagramSocket socket, InternetAddress address) async {
    while (true) {
      socket.send(address.rawAddress, InternetAddress('255.255.255.255'), 6790);
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  _listen(RawDatagramSocket socket,
      void Function(InternetAddress message) callback) async {
    while (true) {
      var r = await _recv(socket);
      callback(InternetAddress.fromRawAddress(r.data));
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
