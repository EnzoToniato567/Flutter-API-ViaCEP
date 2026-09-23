import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/cadastro.dart';
import '../root/file.dart';
import 'cadastro.dart';
import 'style/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cadastro> _cadastros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCadastros();
  }

  Future<void> _carregarCadastros() async {
    try {
      final lista = await CadastroFile.carregar();
      if (mounted) setState(() => _cadastros = lista);
    } catch (_) {
      _mostrarMensagem('Erro ao carregar os cadastros.');
    }
    if (mounted) setState(() => _carregando = false);
  }

  Future<void> _abrirCadastro() async {
    final cadastro = await Navigator.push<Cadastro>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroPage()),
    );

    if (cadastro != null && mounted) {
      setState(() => _cadastros.add(cadastro));
      await CadastroFile.salvar(_cadastros);
      _mostrarMensagem('Cadastro salvo.');
    }
  }

  Future<void> _excluirCadastro(int index) async {
    final pessoa = _cadastros[index];
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir cadastro'),
        content: Text(
          'Tem certeza que deseja excluir o cadastro de ${pessoa.nome}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'EXCLUIR',
              style: TextStyle(color: AppColors.erro),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _cadastros.remove(pessoa));
    await CadastroFile.salvar(_cadastros);
    _mostrarMensagem('Cadastro excluído.');
  }

  Future<void> _editarCadastro(Cadastro pessoa) async {
    final cadastroAtualizado = await Navigator.push<Cadastro>(
      context,
      MaterialPageRoute(builder: (_) => CadastroPage(cadastro: pessoa)),
    );

    if (cadastroAtualizado == null || !mounted) return;

    final index = _cadastros.indexOf(pessoa);
    if (index == -1) return;

    setState(() => _cadastros[index] = cadastroAtualizado);
    await CadastroFile.salvar(_cadastros);
    _mostrarMensagem('Cadastro atualizado.');
  }

  void _mostrarMensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _voltarParaSplash() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void _mostrarDetalhes(Cadastro pessoa) {
    final complemento = pessoa.complemento.trim().isEmpty
        ? 'Não informado'
        : pessoa.complemento;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pessoa.nome),
        content: Text(
          'CEP: ${pessoa.cep}\n'
          'Rua: ${pessoa.logradouro}\n'
          'Número: ${pessoa.numero}\n'
          'Complemento: $complemento\n'
          'Bairro: ${pessoa.bairro}\n'
          'Cidade: ${pessoa.cidade}\n'
          'Estado: ${pessoa.estado}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editarCadastro(pessoa);
            },
            child: const Text('EDITAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas'),
        actions: [
          IconButton(
            tooltip: 'Voltar para a tela inicial',
            onPressed: _voltarParaSplash,
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.verde),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Verde CEP',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            ListTile(
              title: const Text('Pessoas cadastradas'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text(
                'Sair do aplicativo',
                style: TextStyle(color: AppColors.erro),
              ),
              onTap: () => SystemNavigator.pop(),
            ),
          ],
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _cadastros.isEmpty
          ? const Center(child: Text('Nenhuma pessoa cadastrada.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _cadastros.length,
              itemBuilder: (context, index) {
                final pessoa = _cadastros[index];
                return Card(
                  child: ListTile(
                    onTap: () => _mostrarDetalhes(pessoa),
                    title: Text(pessoa.nome),
                    subtitle: Text(
                      '${pessoa.logradouro}, ${pessoa.numero}\n'
                      '${pessoa.cidade} - ${pessoa.estado}\nCEP: ${pessoa.cep}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _excluirCadastro(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}
