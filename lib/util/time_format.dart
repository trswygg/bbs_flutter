import 'package:flustars/flustars.dart';

class TimeFormat {
  static DayFormat _format  = DayFormat.Common;
  String format(String _createdAt) {
    return TimelineUtil.format(
        DateTime.parse(_createdAt).millisecondsSinceEpoch,
        locTimeMs: DateTime.now().millisecondsSinceEpoch,
        locale: 'zh',
        dayFormat: _format);
  }
}
