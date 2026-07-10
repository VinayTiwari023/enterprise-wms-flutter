import 'package:flutter/material.dart';

enum ViewStatus { idle, loading, error, success }

class BaseViewModel with ChangeNotifier {
  ViewStatus _status = ViewStatus.idle;
  String? _errorMessage;

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == ViewStatus.loading;
  bool get hasError => _status == ViewStatus.error;

  void setStatus(ViewStatus status) {
    _status = status;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    _status = ViewStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == ViewStatus.error) {
      _status = ViewStatus.idle;
    }
    notifyListeners();
  }
}
