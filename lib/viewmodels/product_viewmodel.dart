import 'package:cadrey/services/product_service.dart';
import 'package:cadrey/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _service;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  ProductViewModel(this._service);

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    await _service.initialize();

    _products = _service.getAllProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNewProduct({
    required String cdBarras,
    required String nome,
    String descricao = '',
    double preco = 0.0,
    String categoria = '',
    String marca = '',
    double peso = 0.0,
    int estoque = 0,
    String? urlImagem,
  }) async {
    if (nome.isEmpty || cdBarras.isEmpty) return;

    final newProduct = ProductModel(
      cdBarras: cdBarras,
      nome: nome,
      descricao: descricao,
      preco: preco,
      categoria: categoria,
      marca: marca,
      peso: peso,
      estoque: estoque,
      urlImagem: urlImagem,
      dataCadastro: DateTime.now(),
    );

    await _service.addProduct(newProduct);

    await loadProducts();
  }

  Future<void> deleteProduct(ProductModel product) async {
    await _service.deleteProduct(product);

    _products.removeWhere((p) => p.key == product.key);
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    await _service.updateProduct(product);

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product.nome.toLowerCase().contains(_searchQuery) ||
          product.cdBarras.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}