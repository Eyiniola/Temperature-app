import 'package:flutter/material.dart';

void main() {
  runApp(TempConversionApp());
}

class TempConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TempConverter(),
    );
  }
}

class TempConverter extends StatefulWidget {
  @override
  _TempConverterState createState() => _TempConverterState();
}

class _TempConverterState extends State<TempConverter> {
  bool _isFtoC = true; // Flag to track selected conversion
  TextEditingController _inputController = TextEditingController();
  String _result = '';
  List<String> _history = [];

  // Conversion functions
  double _fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  void _convert() {
    setState(() {
      double input = double.tryParse(_inputController.text) ?? 0;
      double convertedTemp =
          _isFtoC ? _fahrenheitToCelsius(input) : _celsiusToFahrenheit(input);
      _result = convertedTemp.toStringAsFixed(2);

      // Add to history
      String conversion = _isFtoC
          ? 'F to C: ${input.toStringAsFixed(1)} = $_result'
          : 'C to F: ${input.toStringAsFixed(1)} = $_result';
      _history.add(conversion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text(
          'Temperature Conversion',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          // Portrait view layout
          if (orientation == Orientation.portrait) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildCommonLayout(),
              ),
            );
          }
          // Landscape view layout
          else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ..._buildCommonLayout(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_history[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Helper method to avoid duplicating layout code
  List<Widget> _buildCommonLayout() {
    return [
      TextField(
        controller: _inputController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Enter temperature',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Convert from F to C'),
          Radio(
            value: true,
            groupValue: _isFtoC,
            onChanged: (bool? value) {
              setState(() {
                _isFtoC = value!;
              });
            },
          ),
          const Text('Convert from C to F'),
          Radio(
            value: false,
            groupValue: _isFtoC,
            onChanged: (bool? value) {
              setState(() {
                _isFtoC = value!;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: _convert,
        child: const Text(
          'Convert',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 16.0),
      Text(
        _result.isEmpty ? 'Result' : 'Result: $_result',
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 20),
      if (MediaQuery.of(context).orientation == Orientation.portrait)
        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_history[index]),
              );
            },
          ),
        ),
    ];
  }
}
