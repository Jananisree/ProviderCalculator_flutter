import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CalculatorProvider.dart';

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          'Calculator',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Display Section: Expression (Smaller) and Result (Larger)
              Container(
                height: availableHeight * 0.33,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.bottomRight,
                child: Consumer<CalculatorProvider>(
                  builder: (context, calculator, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expression Text (Small)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            calculator.expression, // Full expression
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.03,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0), // Space between expression and result
                        // Result Text (Large and Bold)
                        Text(
                          calculator.display, // Calculation result
                          style: TextStyle(
                            fontSize: constraints.maxHeight * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Expanded GridView Section for Buttons
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _buttonLabels.length,
                  itemBuilder: (context, index) {
                    return buildButton(_buttonLabels[index], context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  final List<String> _buttonLabels = [
    'C', '⌫', '%', '×',
    '7', '8', '9', '-',
    '4', '5', '6', '+',
    '1', '2', '3', '÷',
    '.', '0', '00', '=',
  ];

  // Builds a single button widget
  Widget buildButton(String label, BuildContext context) {
    bool isTopRow = ['C', '⌫', '%','÷', '×'].contains(label);
    bool isLastColumn = ['-', '+', '=', ')'].contains(label);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isTopRow || isLastColumn
            ? Colors.orangeAccent
            : Colors.white,
        foregroundColor: isTopRow || isLastColumn
            ? Colors.white
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        var provider = Provider.of<CalculatorProvider>(context, listen: false);
        if (label == 'C') {
          provider.clearAll();
        } else if (label == '⌫') {
          provider.backspace();
        } else if (label == '=') {
          provider.calculate();
        } else {
          provider.input(label);
        }
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
