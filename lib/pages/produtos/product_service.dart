import 'package:cadrey/pages/produtos/Model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionName = 'products';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // No Firestore, a inicialização é automática com a instância,
  // mas mantive o método para compatibilidade com o ViewModel existente.
  Future<void> initialize() async {
    // Pode configurar persistência offline aqui se necessário
  }

  Future<void> addProduct(ProductModel product) async {
    await _db.collection(collectionName).add(product.toMap());
  }

  // O Firestore é assíncrono. O ideal seria retornar Future<List<...>>
  // ou Stream<List<...>>. O ViewModel atual espera List síncrona no getAll,
  // então vamos fazer um fetch único (get) e retornar Future.
  // IMPORTANTE: Isso exigirá ajuste no ViewModel para usar await.
  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  // Retorna Stream para atualizações em tempo real (opcional, mas recomendado)
  Stream<List<ProductModel>> getProductsStream() {
    return _db.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateProduct(ProductModel product) async {
    if (product.id != null) {
      await _db.collection(collectionName).doc(product.id).update(product.toMap());
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    if (product.id != null) {
      await _db.collection(collectionName).doc(product.id).delete();
    }
  }
}