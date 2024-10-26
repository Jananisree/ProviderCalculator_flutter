import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = ''; // Stores the input expression
  String _display = ''; // Stores the current display (result or expression)
  String _lastResult = ''; // Stores the result of the last calculation
  bool _isResultShown = false; // Tracks whether the result is shown

  // Getter for the expression
  String get expression => _expression;

  // Getter for the display (result or current input)
  String get display => _display;

  /// Handles user input.
  void input(String value) {
    if (_isResultShown) {
      _expression = ''; // Clear expression if result was shown
      _isResultShown = false;
    }
    _expression += value; // Add input to expression
    _display = _expression; // Update display with current input
    notifyListeners();
  }

  /// Calculates the result of the expression.
  void calculate() {
    try {
      String finalExpression = _prepareExpression(_expression);
      Parser parser = Parser();
      Expression expression = parser.parse(finalExpression);
      ContextModel contextModel = ContextModel();

      num result = expression.evaluate(EvaluationType.REAL, contextModel);

      // Format the result: If integer, remove decimal part
      _lastResult = (result % 1 == 0)
          ? result.toInt().toString()
          : result.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');

      _display = _lastResult; // Show the result
      _isResultShown = true; // Mark that the result is shown
    } catch (e) {
      _display = 'Error'; // Show error if parsing fails
    }
    notifyListeners();
  }

  /// Prepares the expression by handling special cases like percentage.
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

  /// Clears all input and resets the state.
  void clearAll() {
    _expression = '';
    _display = '';
    _lastResult = '';
    _isResultShown = false;
    notifyListeners();
  }

  /// Deletes the last character from the expression.
  void backspace() {
    if (_expression.isNotEmpty && !_isResultShown) {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression;
      notifyListeners();
    }
  }
}
