import 'package:cadrey/models/product_model.dart';
import 'package:hive/hive.dart';

const String productBoxName = 'products';

class ProductService {
  late Box<ProductModel> _productBox;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(productBoxName)) {
      _productBox = await Hive.openBox<ProductModel>(productBoxName);
    } else {
      _productBox = Hive.box<ProductModel>(productBoxName);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _productBox.add(product);
  }

  List<ProductModel> getAllProducts() {
    return _productBox.values.toList();
  }

  ProductModel? getProduct(dynamic key) {
    return _productBox.get(key);
  }

  Future<void> updateProduct(ProductModel product) async {
    await product.save();
  }

  Future<void> deleteProduct(ProductModel product) async {
    await product.delete();
  }
}
