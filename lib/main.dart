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
        scaffoldBackgroundColor: Colors.white, // Fundo branco
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
      final double imc = weight / (height * height);
      String category;

      if (imc < 18.5) {
        category = "Abaixo do peso";
      } else if (imc >= 18.5 && imc < 24.9) {
        category = "Peso normal";
      } else if (imc >= 25 && imc < 29.9) {
        category = "Sobrepeso";
      } else {
        category = "Obesidade";
      }

      // Navegar para a página de resultados passando os valores do IMC e a categoria
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            imc: imc,
            category: category,
          ),
        ),
      );
    } else {
      // Se os valores não forem válidos, exibe um alerta
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Body'), 
        elevation: 0,
        backgroundColor: Colors.white,  // Cor da AppBar azul
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'BMI Calculator', // Alterado para "BMI Calculator"
              textAlign: TextAlign.left, // Alinhado à esquerda
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Cor preta para o título
              ),
            ),
            const SizedBox(height: 20.0),

            // Duas colunas para peso e altura
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Coluna do Peso
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o conteúdo da coluna
                    children: [
                      const Text(
                        'Your Weight (kg)',
                        style: TextStyle(
                          fontSize: 14.0, // Fonte do label em 14
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Cor preta para o label
                        ),
                        textAlign: TextAlign.center, // Centraliza o label
                      ),
                      const SizedBox(height: 8.0),
                      _buildTextField(
                        controller: _weightController,
                        label: '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                // Coluna da Altura
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o conteúdo da coluna
                    children: [
                      const Text(
                        'Your Height',
                        style: TextStyle(
                          fontSize: 14.0, // Fonte do label em 14
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Cor preta para o label
                        ),
                        textAlign: TextAlign.center, // Centraliza o label
                      ),
                      const SizedBox(height: 8.0),
                      _buildTextField(
                        controller: _heightController,
                        label: '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Botão para calcular
            ElevatedButton(
              onPressed: _calculateIMC,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                backgroundColor: Colors.blue, // Cor azul para o botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Calculate your BMI', // Texto alterado
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 30.0, // Aumentar fonte para 30
        fontWeight: FontWeight.bold, // Texto em negrito
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 14.0, // Fonte do label em 14
          color: Colors.black, // Cor preta para o label
        ),
        border: InputBorder.none, // Remover borda
        filled: true,
        fillColor: Colors.white, // Fundo branco
      ),
      textAlign: TextAlign.center, // Centraliza o texto dentro do campo
    );
  }
}

class ResultPage extends StatelessWidget {
  final double imc;
  final String category;

  const ResultPage({super.key, required this.imc, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado do IMC'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Seu IMC é:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                imc.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                category,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Volta para a tela anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
