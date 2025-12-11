// import 'package:hive_flutter/hive_flutter.dart';
// part 'product_model.g.dart';

class ProductModel {
  String? id;
  String cdBarras;
  String nome;
  String descricao;
  double preco;
  String categoria;
  String marca;
  double peso;
  dynamic estoque;
  String? urlImagem;
  DateTime dataCadastro;

  ProductModel({
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'cdBarras': cdBarras,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoria': categoria,
      'marca': marca,
      'peso': peso,
      'estoque': estoque,
      'urlImagem': urlImagem,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      cdBarras: map['cdBarras'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] as num?)?.toDouble() ?? 0.0,
      categoria: map['categoria'] ?? '',
      marca: map['marca'] ?? '',
      peso: (map['peso'] as num?)?.toDouble() ?? 0.0,
      estoque: map['estoque'] ?? 0,
      urlImagem: map['urlImagem'],
      dataCadastro: map['dataCadastro'] != null 
          ? DateTime.parse(map['dataCadastro']) 
          : DateTime.now(),
    );
  }
}