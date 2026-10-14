abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 300);

  static const gauge = Duration(milliseconds: 600);

  static const pulse = Duration(milliseconds: 1400);

  static const clockTick = Duration(seconds: 1);

  static const weatherRefresh = Duration(minutes: 15);

  static const locationTimeout = Duration(seconds: 25);

  static const requestTimeout = Duration(seconds: 20);

  static const mockLatency = Duration(milliseconds: 350);

  static const loaderSpin = Duration(milliseconds: 1100);
  static const loaderSlide = Duration(milliseconds: 1500);

  static const shimmer = Duration(milliseconds: 1500);
}
