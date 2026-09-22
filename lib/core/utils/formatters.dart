import 'package:intl/intl.dart';

abstract final class Formatters {
  static final _date = DateFormat('MMM dd, yyyy');
  static final _time = DateFormat('h:mm a');
  static final _timeWithSeconds = DateFormat('h:mm:ss a');

  static String percent(double value, {int decimals = 1}) => '${_trimNumber(value, decimals)}%';

  static String temperature(double value, {int decimals = 1}) =>
      '${_trimNumber(value, decimals)}°C';

  static String centimeters(double value, {int decimals = 1}) =>
      '${_trimNumber(value, decimals)} cm';

  static String speed(double value, {int decimals = 1}) => '${_trimNumber(value, decimals)} km/h';

  static String range(int min, int max) => '$min% – $max%';

  static String date(DateTime value) => _date.format(value);

  static String time(DateTime value) => _time.format(value);

  static String timeWithSeconds(DateTime value) => _timeWithSeconds.format(value);

  static String _trimNumber(double value, int decimals) {
    final fixed = value.toStringAsFixed(decimals);
    if (!fixed.contains('.')) return fixed;
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
