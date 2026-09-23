import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cadastro.dart';
import '../services/viacep.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key, this.cadastro});

  final Cadastro? cadastro;

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _cep = TextEditingController();
  final _rua = TextEditingController();
  final _bairro = TextEditingController();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _numero = TextEditingController();
  final _complemento = TextEditingController();

  bool _buscandoCep = false;
  bool _cepEncontrado = false;
  String? _erroCep;

  @override
  void initState() {
    super.initState();

    final cadastro = widget.cadastro;
    if (cadastro == null) return;

    _nome.text = cadastro.nome;
    _cep.text = cadastro.cep.replaceAll(RegExp(r'\D'), '');
    _rua.text = cadastro.logradouro;
    _bairro.text = cadastro.bairro;
    _cidade.text = cadastro.cidade;
    _estado.text = cadastro.estado;
    _numero.text = cadastro.numero;
    _complemento.text = cadastro.complemento;
    _cepEncontrado = true;
  }

  @override
  void dispose() {
    _nome.dispose();
    _cep.dispose();
    _rua.dispose();
    _bairro.dispose();
    _cidade.dispose();
    _estado.dispose();
    _numero.dispose();
    _complemento.dispose();
    super.dispose();
  }

  void _verificarCep(String valor) {
    if (valor.length == 8) {
      _buscarCep();
    } else {
      _limparEndereco();
      setState(() {
        _cepEncontrado = false;
        _erroCep = null;
      });
    }
  }

  Future<void> _buscarCep() async {
    if (_cep.text.length != 8 || _buscandoCep) return;

    final cepDigitado = _cep.text;

    setState(() {
      _buscandoCep = true;
      _erroCep = null;
    });

    try {
      final endereco = await ViaCepService.buscar(cepDigitado);
      if (!mounted || _cep.text != cepDigitado) return;

      _rua.text = endereco.logradouro;
      _bairro.text = endereco.bairro;
      _cidade.text = endereco.cidade;
      _estado.text = endereco.estado;
      setState(() => _cepEncontrado = true);
    } on ViaCepException catch (erro) {
      if (!mounted) return;
      _limparEndereco();
      setState(() {
        _cepEncontrado = false;
        _erroCep = erro.message;
      });
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
  }

  void _limparEndereco() {
    _rua.clear();
    _bairro.clear();
    _cidade.clear();
    _estado.clear();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    if (!_cepEncontrado) {
      setState(() => _erroCep = 'Consulte um CEP válido.');
      return;
    }

    final cep = '${_cep.text.substring(0, 5)}-${_cep.text.substring(5)}';
    final cadastro = Cadastro(
      nome: _nome.text.trim(),
      cep: cep,
      logradouro: _rua.text,
      bairro: _bairro.text,
      cidade: _cidade.text,
      estado: _estado.text,
      numero: _numero.text.trim(),
      complemento: _complemento.text.trim(),
    );

    Navigator.pop(context, cadastro);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.cadastro != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar cadastro' : 'Novo cadastro'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _campo(_nome, 'Nome', obrigatorio: true),
            TextFormField(
              controller: _cep,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: _verificarCep,
              decoration: InputDecoration(
                labelText: 'CEP',
                errorText: _erroCep,
                suffixIcon: _buscandoCep
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: _buscarCep,
                        child: const Text('BUSCAR'),
                      ),
              ),
              validator: (valor) =>
                  valor?.length == 8 ? null : 'Digite os 8 números do CEP.',
            ),
            const SizedBox(height: 12),
            _campo(_rua, 'Rua', somenteLeitura: true),
            _campo(_bairro, 'Bairro', somenteLeitura: true),
            _campo(_cidade, 'Cidade', somenteLeitura: true),
            _campo(_estado, 'Estado', somenteLeitura: true),
            _campo(_numero, 'Número', obrigatorio: true),
            _campo(_complemento, 'Complemento'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _buscandoCep ? null : _salvar,
              child: Text(editando ? 'ATUALIZAR' : 'SALVAR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label, {
    bool obrigatorio = false,
    bool somenteLeitura = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: somenteLeitura,
        decoration: InputDecoration(labelText: label),
        validator: obrigatorio
            ? (valor) => valor == null || valor.trim().isEmpty
                  ? 'Campo obrigatório.'
                  : null
            : null,
      ),
    );
  }
}
