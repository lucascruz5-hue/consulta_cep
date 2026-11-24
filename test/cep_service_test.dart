import 'package:flutter_test/flutter_test.dart';
import 'package:consulta_cep/models/endereco_model.dart';

void main() {
  group('EnderecoModel Tests', () {
    test('deve converter JSON valido do ViaCEP para EnderecoModel', () {
      final json = {
        'cep': '01001-000',
        'logradouro': 'Praça da Sé',
        'complemento': 'lado ímpar',
        'bairro': 'Sé',
        'localidade': 'São Paulo',
        'uf': 'SP',
        'ddd': '11',
      };

      final endereco = EnderecoModel.fromJson(json);

      expect(endereco.cep, '01001-000');
      expect(endereco.logradouro, 'Praça da Sé');
      expect(endereco.complemento, 'lado ímpar');
      expect(endereco.bairro, 'Sé');
      expect(endereco.localidade, 'São Paulo');
      expect(endereco.uf, 'SP');
      expect(endereco.ddd, '11');
      expect(endereco.erro, false);
    });

    test('deve identificar resposta de CEP nao encontrado com erro: true', () {
      final json = {'erro': true};
      final endereco = EnderecoModel.fromJson(json);

      expect(endereco.erro, true);
    });

    test('deve identificar resposta de CEP nao encontrado com erro: "true"', () {
      final json = {'erro': 'true'};
      final endereco = EnderecoModel.fromJson(json);

      expect(endereco.erro, true);
    });
  });
}
