import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _display = '';
  String _lastResult = '';
  bool _isResultShown = false;

  String get display => _display;

  void input(String value) {
    // Start a new expression based on the last result if a result was shown
    if (_isResultShown) {
      _display = _lastResult;
      _isResultShown = false;
    }
    _display += value;
    notifyListeners();
  }

  void calculate() {
    try {

      String finalExpression = _display.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression expression = parser.parse(finalExpression);
      ContextModel contextModel = ContextModel();

      num result = expression.evaluate(EvaluationType.REAL, contextModel);

      _lastResult = (result % 1 == 0)
          ? result.toInt().toString()
          : result.toString();

      _display = _lastResult;
      _isResultShown = true;
    } catch (e) {
      _display = 'Error';
    }
    notifyListeners();
  }

  void clearAll() {
    _display = '';
    _lastResult = '';
    _isResultShown = false;
    notifyListeners();
  }

  void backspace() {
    if (_display.isNotEmpty && !_isResultShown) {
      _display = _display.substring(0, _display.length - 1);
      notifyListeners();
    }
  }
}
