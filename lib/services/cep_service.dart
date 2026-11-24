import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco_model.dart';

class CepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  Future<EnderecoModel> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception('O CEP deve conter 8 dígitos.');
    }

    final url = Uri.parse('$_baseUrl/$cepLimpo/json/');
    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Tempo limite de conexão esgotado.'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados = jsonDecode(response.body);
      final endereco = EnderecoModel.fromJson(dados);

      if (endereco.erro) {
        throw Exception('CEP não encontrado na base de dados do ViaCEP.');
      }

      return endereco;
    } else {
      throw Exception('Erro ao consultar ViaCEP: Status ${response.statusCode}');
    }
  }
}
