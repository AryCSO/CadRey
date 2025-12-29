import 'package:cadrey/pages/produtos/Model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionName = 'Cad. Produtos';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initialize() async {
  }

  Future<void> addProduct(ProductModel product) async {
    await _db.collection(collectionName).add(product.toMap());
  }

  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

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