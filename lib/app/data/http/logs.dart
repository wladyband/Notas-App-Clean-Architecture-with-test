part of 'http.dart';

void _printLogs(Map<String, dynamic> logs, StackTrace? stackTrace) {
  if (kDebugMode) {
    log('''
____________________________
${const JsonEncoder.withIndent(' ').convert(logs)}
____________________________

''', stackTrace: stackTrace);
  }
}
