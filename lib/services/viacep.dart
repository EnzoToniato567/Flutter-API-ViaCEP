import 'dart:convert';

import 'package:http/http.dart' as http;

class EnderecoViaCep {
  const EnderecoViaCep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;

  factory EnderecoViaCep.fromMap(Map<String, dynamic> map) => EnderecoViaCep(
    cep: map['cep'] as String? ?? '',
    logradouro: map['logradouro'] as String? ?? '',
    bairro: map['bairro'] as String? ?? '',
    cidade: map['localidade'] as String? ?? '',
    estado: map['estado'] as String? ?? map['uf'] as String? ?? '',
  );
}

class ViaCepException implements Exception {
  const ViaCepException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ViaCepService {
  static Future<EnderecoViaCep> buscar(String cep) async {
    final apenasDigitos = cep.replaceAll(RegExp(r'\D'), '');
    if (apenasDigitos.length != 8) {
      throw const ViaCepException('Digite um CEP com 8 números.');
    }

    try {
      final resposta = await http
          .get(Uri.https('viacep.com.br', '/ws/$apenasDigitos/json/'))
          .timeout(const Duration(seconds: 10));

      if (resposta.statusCode != 200) {
        throw const ViaCepException('Não foi possível consultar esse CEP.');
      }

      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (dados['erro'] == true) {
        throw const ViaCepException('CEP não encontrado.');
      }
      return EnderecoViaCep.fromMap(dados);
    } on ViaCepException {
      rethrow;
    } on Object {
      throw const ViaCepException(
        'Sem conexão com o ViaCEP. Verifique sua internet e tente novamente.',
      );
    }
  }
}
