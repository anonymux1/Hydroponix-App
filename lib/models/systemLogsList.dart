import 'systemLogs.dart';

class SystemLogList {
  List<SystemLog>? systemLogList;

  SystemLogList(
      this.systemLogList
      );

  List<SystemLog>? getSystemList()
  {
    return systemLogList;
  }
}