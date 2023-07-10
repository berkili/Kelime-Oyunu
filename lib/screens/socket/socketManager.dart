import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  // ignore: avoid_init_to_null
  static IO.Socket? socket = null;

  static Future connect(token) {
    var completer = new Completer();

    Future.delayed(const Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        completer.completeError(new Exception('timeout'));
      }
    });

    socket = IO.io(
      'http://192.168.0.10:3000',
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .build(),
    );
    socket!.connect();
    socket!.once('connect', (data) {
      socket!.emit('authenticate', {'token': token});
      socket!.once('authenticated', (data) {
        if (data['success']) {
          completer.complete();
        } else {
          completer.completeError(
            new Exception('unauthorized'),
          );
          disconnect();
        }
      });
    });

    socket!.once('connect_error', (data) {
      completer.completeError(
        new Exception('connect_error'),
      );
      disconnect();
    });
    socket!.once('connect_timeout', (data) {
      completer.completeError(
        new Exception('connect_timeout'),
      );
      disconnect();
    });
    return completer.future;
  }

  static disconnect() {
    socket?.dispose();
    socket = null;
  }
}
