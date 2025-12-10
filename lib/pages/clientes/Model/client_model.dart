class DependentModel {
  String idDependente;
  String idCliente;
  String nome;
  String parentesco;
  DateTime dataNascimento;

  DependentModel({
    required this.idDependente,
    required this.idCliente,
    required this.nome,
    required this.parentesco,
    required this.dataNascimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDependente': idDependente,
      'idCliente': idCliente,
      'nome': nome,
      'parentesco': parentesco,
      'dataNascimento': dataNascimento.toIso8601String(),
    };
  }

  factory DependentModel.fromMap(Map<String, dynamic> map) {
    return DependentModel(
      idDependente: map['idDependente'] ?? '',
      idCliente: map['idCliente'] ?? '',
      nome: map['nome'] ?? '',
      parentesco: map['parentesco'] ?? '',
      dataNascimento: map['dataNascimento'] != null 
          ? DateTime.parse(map['dataNascimento']) 
          : DateTime.now(),
    );
  }
}

class ClientModel {
  String? id; // ID do documento Firestore
  String idCliente; // ID interno de negócio (GUID)
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
  List<DependentModel>? dependentes;

  ClientModel({
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String(),
      'telefone': telefone,
      'email': email,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
      'empresaCnpj': empresaCnpj,
      'cargo': cargo,
      'dataCadastro': dataCadastro.toIso8601String(),
      'dependentes': dependentes?.map((x) => x.toMap()).toList(),
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ClientModel(
      id: documentId,
      idCliente: map['idCliente'] ?? '',
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      dataNascimento: map['dataNascimento'] != null 
          ? DateTime.parse(map['dataNascimento']) 
          : DateTime.now(),
      telefone: map['telefone'] ?? '',
      email: map['email'] ?? '',
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      numero: map['numero'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      complemento: map['complemento'],
      empresaCnpj: map['empresaCnpj'],
      cargo: map['cargo'],
      dataCadastro: map['dataCadastro'] != null 
          ? DateTime.parse(map['dataCadastro']) 
          : DateTime.now(),
      dependentes: map['dependentes'] != null
          ? List<DependentModel>.from(
              (map['dependentes'] as List<dynamic>).map(
                (x) => DependentModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }
}