import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _display = '';
  String _lastResult = '';
  bool _isResultShown = false;


  String get expression => _expression;


  String get display => _display;

  void input(String value) {
    if (_isResultShown) {
      _expression = '';
      _isResultShown = false;
    }
    _expression += value;
    _display = _expression;
    notifyListeners();
  }

  void calculate() {
    try {
      String finalExpression = _prepareExpression(_expression);
      Parser parser = Parser();
      Expression expression = parser.parse(finalExpression);
      ContextModel contextModel = ContextModel();

      num result = expression.evaluate(EvaluationType.REAL, contextModel);


      _lastResult = (result % 1 == 0)
          ? result.toInt().toString()
          : result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');

      _display = _lastResult;
      _isResultShown = true;
    } catch (e) {
      _display = 'Error';
    }
    notifyListeners();
  }

  String _prepareExpression(String expression) {
    String processedExpression = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    // Handle percentage (e.g., 50% -> (50 * 0.01))
    processedExpression = processedExpression.replaceAllMapped(
      RegExp(r'(\d+)%'),
          (match) => '(${match[1]} * 0.01)',
    );

    return processedExpression;
  }

  void clearAll() {
    _expression = '';
    _display = '';
    _lastResult = '';
    _isResultShown = false;
    notifyListeners();
  }

  void backspace() {
    if (_expression.isNotEmpty && !_isResultShown) {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression;
      notifyListeners();
    }
  }
}
