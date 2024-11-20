import 'package:flutter/material.dart';

void main() {
  runApp(const IMCCalculatorApp());
}

class IMCCalculatorApp extends StatelessWidget {
  const IMCCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _calculateIMC() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      final double imc = weight / ((height/100) * (height/100)) ;
      String category;

      if (imc < 18.5) {
        category = "Underweight";
      } else if (imc >= 18.5 && imc < 24.9) {
        category = "Normal";
      } else if (imc >= 25 && imc < 29.9) {
        category = "Overwight";
      } else {
        category = "Obesity";
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            imc: imc,
            category: category,
            weight: _weightController.text,
            height: _heightController.text,
            onBack: _resetFields,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Por favor, insira valores válidos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _resetFields() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Body',
        style: TextStyle(
        fontSize: 16.0,  // Diminuindo o tamanho da fonte
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
      ),
      body: IMCCalculatorBody(
        heightController: _heightController,
        weightController: _weightController,
        onCalculate: _calculateIMC,
        isEditable: true,
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final double imc;
  final String category;
  final String weight;
  final String height;
  final VoidCallback onBack;

  const ResultPage({
    super.key,
    required this.imc,
    required this.category,
    required this.weight,
    required this.height,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Body',
        style: TextStyle(
        fontSize: 16.0,  // Diminuindo o tamanho da fonte
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Expanded(
            child: IMCCalculatorBody(
              heightController: TextEditingController(text: height),
              weightController: TextEditingController(text: weight),
              onCalculate: () {},
              isEditable: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
             
            child: Column(
              children: [
                const Text(
                  'Your BMI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                      ),
                ),
                Text(
                  imc.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      onBack();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Calculate BMI again',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Cor do texto clicável
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IMCCalculatorBody extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final VoidCallback onCalculate;
  final bool isEditable;

  const IMCCalculatorBody({
    super.key,
    required this.heightController,
    required this.weightController,
    required this.onCalculate,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'BMI Calculator',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IMCInfoPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Icon(
                  Icons.info,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGenderColumn('', 'assets/images/man.png'),
              const SizedBox(width: 16.0),
              _buildGenderColumn('', 'assets/images/woman.png'),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputColumn('Your Weight (kg)', weightController, isEditable),
              const SizedBox(width: 16.0),
              _buildInputColumn('Your Height (cm)', heightController, isEditable),
            ],
          ),
          const SizedBox(height: 20.0),
          if (isEditable)
            ElevatedButton(
              onPressed: onCalculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Calculate your BMI',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderColumn(String label, String imagePath) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          print("$label selecionado");
        },
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputColumn(
      String label, TextEditingController controller, bool isEditable) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            enabled: isEditable,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
            border: InputBorder.none, // Remove o underline
            ),            
          ),
        ],
      ),
    );
  }
}

class IMCInfoPage extends StatelessWidget {
  const IMCInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Body',
        style: TextStyle(
        fontSize: 16.0,  // Diminuindo o tamanho da fonte
          ),
        ),
        
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black54,
      ),
      body: const Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI categories',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
            Text(
              'Less than 18.5',
              style: TextStyle(fontSize: 30.0 , fontWeight: FontWeight.bold),
            ),
            Text(
              "you're underweight",
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 30.0),
            Text(
              '18.5 to 24.9',
              style: TextStyle(fontSize: 30.0 , fontWeight: FontWeight.bold),
            ),
            Text(
              "you're normal",
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 30.0),
            Text(
              '25 to 29.9',
              style: TextStyle(fontSize: 30.0 , fontWeight: FontWeight.bold),
            ),
            Text(
              "you´re overweight",
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 30.0),
            Text(
              '30 or more',
              style: TextStyle(fontSize: 30.0 , fontWeight: FontWeight.bold),
            ),
            Text(
              'obesity',
              style: TextStyle(fontSize: 30.0),
            ),
            
          ],
        ),
      ),
    );
  }
}
