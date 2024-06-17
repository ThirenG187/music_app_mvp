import 'dart:io';

class ServerConstants {
  static String serverURL = ServerConstants.getServerURL;

  static String get getServerURL {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else if (Platform.isWindows) {
      return 'http://192.168.88.254:8000';
    }

    return 'http://192.168.88.254:8000';
  }
}
