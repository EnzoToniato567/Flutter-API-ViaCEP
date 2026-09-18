import 'dart:convert';

import 'package:flutter_viacep_api/models/cadastro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroFile {
  static const String chave = 'cadastros';

  static Future<List<Cadastro>> carregar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(chave);

    if (dados == null) {
      return [];
    }

    final lista = jsonDecode(dados) as List<dynamic>;

    return lista
        .map((item) => Cadastro.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> salvar(List<Cadastro> cadastros) async {
    final prefs = await SharedPreferences.getInstance();

    final dados = cadastros.map((cadastro) => cadastro.toMap()).toList();

    await prefs.setString(chave, jsonEncode(dados));
  }
}
