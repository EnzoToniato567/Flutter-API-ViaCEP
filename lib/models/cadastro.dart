class Cadastro {
  const Cadastro({
    required this.nome,
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numero,
    required this.complemento,
  });

  final String nome;
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;
  final String numero;
  final String complemento;

  String get enderecoResumido => '$logradouro, $numero';

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'cep': cep,
    'logradouro': logradouro,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    'numero': numero,
    'complemento': complemento,
  };

  factory Cadastro.fromMap(Map<String, dynamic> map) => Cadastro(
    nome: map['nome'] as String? ?? '',
    cep: map['cep'] as String? ?? '',
    logradouro: map['logradouro'] as String? ?? '',
    bairro: map['bairro'] as String? ?? '',
    cidade: map['cidade'] as String? ?? '',
    estado: map['estado'] as String? ?? '',
    numero: map['numero'] as String? ?? '',
    complemento: map['complemento'] as String? ?? '',
  );
}
