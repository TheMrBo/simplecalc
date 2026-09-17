import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _expression = '';
  double? _firstOperand;
  String? _pendingOperator;
  String? _activeHighlightOperator;
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC' || value == 'C') {
        _output = '0';
        _expression = '';
        _firstOperand = null;
        _pendingOperator = null;
        _activeHighlightOperator = null;
        _shouldResetDisplay = false;
      } else if (value == '+/-') {
        if (_output != '0' && _output != 'Error') {
          if (_output.startsWith('-')) {
            _output = _output.substring(1);
          } else {
            _output = '-$_output';
          }
        }
      } else if (value == '%') {
        if (_output != 'Error') {
          final double? val = double.tryParse(_output);
          if (val != null) {
            _output = _formatResult(val / 100);
          }
        }
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        if (_output == 'Error') return;

        final double currentVal = double.tryParse(_output) ?? 0;
        if (_firstOperand != null && _pendingOperator != null && !_shouldResetDisplay) {
          final double? result = _calculate(_firstOperand!, currentVal, _pendingOperator!);
          if (result == null) {
            _output = 'Error';
            _firstOperand = null;
            _pendingOperator = null;
            _activeHighlightOperator = null;
            _expression = '';
            return;
          }
          _firstOperand = result;
          _output = _formatResult(result);
        } else {
          _firstOperand = currentVal;
        }

        _pendingOperator = value;
        _activeHighlightOperator = value;
        _expression = '${_formatResult(_firstOperand!)} $value';
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_firstOperand != null && _pendingOperator != null && _output != 'Error') {
          final double secondOperand = double.tryParse(_output) ?? 0;
          _expression = '${_formatResult(_firstOperand!)} $_pendingOperator ${_formatResult(secondOperand)} =';
          final double? result = _calculate(_firstOperand!, secondOperand, _pendingOperator!);
          if (result == null) {
            _output = 'Error';
          } else {
            _output = _formatResult(result);
          }
          _firstOperand = null;
          _pendingOperator = null;
          _activeHighlightOperator = null;
          _shouldResetDisplay = true;
        }
      } else if (value == '.') {
        _activeHighlightOperator = null;
        if (_shouldResetDisplay || _output == 'Error') {
          _output = '0.';
          _shouldResetDisplay = false;
        } else if (!_output.contains('.')) {
          _output += '.';
        }
      } else {
        // Digits 0-9
        _activeHighlightOperator = null;
        if (_output == '0' || _shouldResetDisplay || _output == 'Error') {
          _output = value;
          _shouldResetDisplay = false;
        } else {
          if (_output.length < 12) {
            _output += value;
          }
        }
      }
    });
  }

  double? _calculate(double op1, double op2, String op) {
    switch (op) {
      case '+':
        return op1 + op2;
      case '-':
        return op1 - op2;
      case '×':
        return op1 * op2;
      case '÷':
        if (op2 == 0) return null;
        return op1 / op2;
      default:
        return op2;
    }
  }

  String _formatResult(double val) {
    if (val.isNaN || val.isInfinite) return 'Error';
    if (val == val.toInt().toDouble()) {
      return val.toInt().toString();
    }
    String str = val.toStringAsFixed(8);
    while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
        break;
      }
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  Widget _buildButton(
    String label, {
    required Color backgroundColor,
    required Color textColor,
    int flex = 1,
    bool isSelected = false,
  }) {
    final Color effectiveBg = isSelected ? Colors.white : backgroundColor;
    final Color effectiveFg = isSelected ? const Color(0xFFFF9F0A) : textColor;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double buttonHeight = constraints.maxHeight;
            return Center(
              child: SizedBox(
                height: buttonHeight,
                width: flex == 1 ? buttonHeight : constraints.maxWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: effectiveBg,
                    foregroundColor: effectiveFg,
                    elevation: 0,
                    shape: flex == 1
                        ? const CircleBorder()
                        : const StadiumBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => _onButtonPressed(label),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: label.length > 2 ? 22 : 30,
                        fontWeight: FontWeight.w400,
                        color: effectiveFg,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFFF9F0A);
    const darkGrayColor = Color(0xFF333333);
    const lightGrayColor = Color(0xFFA5A5A5);

    final String clearLabel = (_output == '0' && _firstOperand == null) ? 'AC' : 'C';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_expression.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _expression,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _output,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _output.length > 8 ? 48 : 68,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Keypad Section
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton(clearLabel, backgroundColor: lightGrayColor, textColor: Colors.black),
                          _buildButton('+/-', backgroundColor: lightGrayColor, textColor: Colors.black),
                          _buildButton('%', backgroundColor: lightGrayColor, textColor: Colors.black),
                          _buildButton('÷', backgroundColor: orangeColor, textColor: Colors.white, isSelected: _activeHighlightOperator == '÷'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('8', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('9', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('×', backgroundColor: orangeColor, textColor: Colors.white, isSelected: _activeHighlightOperator == '×'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('5', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('6', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('-', backgroundColor: orangeColor, textColor: Colors.white, isSelected: _activeHighlightOperator == '-'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('2', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('3', backgroundColor: darkGrayColor, textColor: Colors.white),
                          _buildButton('+', backgroundColor: orangeColor, textColor: Colors.white, isSelected: _activeHighlightOperator == '+'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', backgroundColor: darkGrayColor, textColor: Colors.white, flex: 1),
                          _buildButton('.', backgroundColor: darkGrayColor, textColor: Colors.white, flex: 1),
                          _buildButton('=', backgroundColor: orangeColor, textColor: Colors.white, flex: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
