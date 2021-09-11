
part of 'main.dart';

class CoreNotifier extends Notify with _CoreNotifiable {
  double? _progressPercentage;
  double? get progressPercentage => _progressPercentage;
  set progressPercentage(double? value) => notifyIf<double?>(_progressPercentage, _progressPercentage = value);

  String _message = 'Initializing';
  String get message => _message;
  set message(String value) => notifyIf<String>(_message, _message = value);

  bool _nodeFocus = false;
  bool get nodeFocus => _nodeFocus;
  set nodeFocus(bool value) => notifyIf<bool>(_nodeFocus, _nodeFocus = value);


  // String _suggestionQuery = '';
  // String get suggestionQuery => _suggestionQuery;
  // set suggestionQuery(String value) => notifyIf<String>(_suggestionQuery, _suggestionQuery = value);

  // String _definitionQuery = '';
  // String get definitionQuery => _definitionQuery;
  // set definitionQuery(String value) => notifyIf<String>(_definitionQuery, _definitionQuery = value);
}

mixin _CoreNotifiable{}