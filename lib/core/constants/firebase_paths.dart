// core/constants/firebase_paths.dart

class FirebasePaths {
  FirebasePaths._();

  static String device(String deviceId) {
    return 'devices/$deviceId';
  }

  static String control(String deviceId) {
    return '${device(deviceId)}/control';
  }

  static String sensors(String deviceId) {
    return '${device(deviceId)}/sensors';
  }

  static String weather(String deviceId) {
    return '${device(deviceId)}/weather';
  }

  static String pumpCommand(String deviceId) {
    return '${control(deviceId)}/pump_command';
  }
}