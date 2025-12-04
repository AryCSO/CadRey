import 'package:hive_flutter/hive_flutter.dart';
part 'client_model.g.dart';

@HiveType(typeId: 2)
class DependentModel extends HiveObject {
  @HiveField(0)
  late String idDependente;

  @HiveField(1)
  late String idCliente;

  @HiveField(2)
  late String nome;

  @HiveField(3)
  late String parentesco;

  @HiveField(4)
  late DateTime dataNascimento;

  DependentModel({
    required this.idDependente,
    required this.idCliente,
    required this.nome,
    required this.parentesco,
    required this.dataNascimento,
  });
}

@HiveType(typeId: 1)
class ClientModel extends HiveObject {
  @HiveField(0)
  late String idCliente;

  @HiveField(1)
  late String nome;

  @HiveField(2)
  late String cpf;

  @HiveField(3)
  late DateTime dataNascimento;

  @HiveField(4)
  late String telefone;

  @HiveField(5)
  late String email;

  @HiveField(6)
  late String cep;

  @HiveField(7)
  late String logradouro;

  @HiveField(8)
  late String numero;

  @HiveField(9)
  late String bairro;

  @HiveField(10)
  late String cidade;

  @HiveField(11)
  late String estado;

  @HiveField(12)
  String? complemento;

  @HiveField(13)
  String? empresaCnpj;

  @HiveField(14)
  String? cargo;

  @HiveField(15)
  late DateTime dataCadastro;

  @HiveField(16)
  List<DependentModel>? dependentes;

  ClientModel({
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
}
