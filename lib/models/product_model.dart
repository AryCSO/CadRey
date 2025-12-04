import 'package:hive_flutter/hive_flutter.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  late String cdBarras;

  @HiveField(1)
  late String nome;

  @HiveField(2)
  late String descricao;

  @HiveField(3)
  late double preco;

  @HiveField(4)
  late String categoria;

  @HiveField(5)
  late String marca;

  @HiveField(6)
  late double peso;

  @HiveField(7)
  late dynamic estoque;

  @HiveField(8)
  String? urlImagem;

  @HiveField(9)
  late DateTime dataCadastro;

  ProductModel({
    required this.cdBarras,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.marca,
    required this.peso,
    required this.estoque,
    this.urlImagem,
    required this.dataCadastro,
  });
}
