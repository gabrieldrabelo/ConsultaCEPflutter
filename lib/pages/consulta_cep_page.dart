import 'package:flutter/material.dart';
import '../models/cep_model.dart';
import '../services/viacep_service.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({Key? key}) : super(key: key);

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  final TextEditingController _cepController = TextEditingController();
  CepModel? _cepModel;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _consultarCep() async {
    final cep = _cepController.text.trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _errorMessage = 'Por favor, insira um CEP válido com 8 números.';
        _cepModel = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cepModel = null;
    });

    try {
      final cepResult = await ViaCepService.consultarCep(cep);
      setState(() {
        if (cepResult == null) {
          _errorMessage = 'CEP não encontrado.';
          _cepModel = null;
        } else {
          _cepModel = cepResult;
          _errorMessage = null;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao consultar o CEP: $e';
        _cepModel = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta CEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              )
            else if (_cepModel != null)
              _buildResultado(_cepModel!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _consultarCep,
        tooltip: 'Consultar',
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildResultado(CepModel cep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CEP: ${cep.cep}', style: const TextStyle(fontSize: 16)),
        Text('Logradouro: ${cep.logradouro}', style: const TextStyle(fontSize: 16)),
        Text('Complemento: ${cep.complemento}', style: const TextStyle(fontSize: 16)),
        Text('Bairro: ${cep.bairro}', style: const TextStyle(fontSize: 16)),
        Text('Cidade: ${cep.localidade}', style: const TextStyle(fontSize: 16)),
        Text('Estado: ${cep.uf}', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}