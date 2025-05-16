import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cep_model.dart';

class ViaCepService {
  static Future<CepModel?> consultarCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('erro')) {
        return null;
      } else {
        return CepModel.fromJson(data);
      }
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }
}