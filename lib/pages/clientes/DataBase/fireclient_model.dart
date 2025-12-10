class FireDependentModel {
  String idDependente;
  String idCliente;
  String nome;
  String parentesco;
  DateTime dataNascimento;

  FireDependentModel({
    required this.idDependente,
    required this.idCliente,
    required this.nome,
    required this.parentesco,
    required this.dataNascimento,
  });
}

class FireClientModel{
  String idCliente;
  String nome;
  String cpf;
  DateTime dataNascimento;
  String telefone;
  String email;
  String cep;
  String logradouro;
  String numero;
  String bairro;
  String cidade;
  String estado;
  String? complemento;
  String? empresaCnpj;
  String? cargo;
  DateTime dataCadastro;
  List<FireDependentModel>? dependentes;

  FireClientModel({
    required this.idCliente,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
    this.empresaCnpj,
    this.cargo,
    required this.dataCadastro,
    this.dependentes,
  });

  FireClientModel.fromMap(Map<String, dynamic> map) 
    : idCliente = map['idCliente'],
      nome = map['nome'],
      cpf = map['cpf'],
      dataNascimento = map['dataNascimento'],
      telefone = map['telefone'],
      email = map['email'],
      cep = map['cep'],
      logradouro = map['logradouro'],
      numero = map['numero'],
      bairro = map['bairro'],
      cidade = map['cidade'],
      estado = map['estado'],
      complemento = map['complemento'],
      empresaCnpj = map['empresaCnpj'],
      cargo = map['cargo'],
      dataCadastro = map['dataCadastro'],
      dependentes = map['dependente'];
    
  Map<String, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      "telefone": telefone,
      "email": email,
      "cep": cep,
      "logradouro": logradouro,
      "numero": numero,
      "bairro": bairro,
      "cidade": cidade,
      "estado": estado,
      "complemento": complemento,
      "empresaCnpj": empresaCnpj,
      "cargo": cargo,
      "dataCadastro": dataCadastro,
      "dependentes": dependentes
    };
  }
}
