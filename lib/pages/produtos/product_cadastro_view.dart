import 'package:cadrey/pages/produtos/Model/product_model.dart';
import 'package:cadrey/pages/produtos/product_modal.dart';
import 'package:cadrey/pages/produtos/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductCadastroView extends StatefulWidget {
  const ProductCadastroView({super.key});

  @override
  State<ProductCadastroView> createState() => _ProductCadastroViewState();
}

class _ProductCadastroViewState extends State<ProductCadastroView> {
  ProductModel? _selectedProduct;
  final bool _isCreatingNew = false;

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, 
                vertical: 5
              ),
              
              color: Colors.teal[700],

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text('Gestão de Produtos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (!_isCreatingNew && _selectedProduct == null)

                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          cadProductModal(context, product: null);
                        });
                      },

                      label: const Icon(
                        Icons.add, 
                        size: 18
                      ),

                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0x0007171b),
                      ),
                    ),
                ],
              ),
            ),
            
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,

                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Color(0x0007171b))),
                        color: Color(0x0007171b),
                      ),
                      
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),

                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pesquisar Nome ou Código...',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.search, color: Colors.white),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Color(0x60021D3B),
                                isDense: true,
                              ),

                              onChanged: (query) {
                                viewModel.setSearchQuery(query);
                              },
                            ),
                          ),

                          const Divider(height: 1),

                          Expanded(
                            child: viewModel.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : viewModel.filteredProducts.isEmpty
                                ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),

                                    child: Text(
                                      viewModel.products.isEmpty
                                        ? 'Nenhum produto cadastrado.'
                                        : 'Nenhum resultado para "${viewModel.searchQuery}"',
                                      textAlign: TextAlign.center,

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )

                                    : ListView.builder(
                                        itemCount: viewModel.filteredProducts.length,

                                        itemBuilder: (context, index) {
                                          final product = viewModel.filteredProducts[index];
                                          final isSelected = _selectedProduct == product;

                                          return Container(
                                            color: isSelected 
                                            ? Colors.teal : null,

                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.teal,

                                                child: Text(
                                                  product.estoque.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white, 
                                                    fontSize: 12
                                                  ),
                                                ),
                                              ),

                                              title: Text(
                                                product.nome,
                                                style: TextStyle(
                                                  fontWeight: isSelected 
                                                  ? FontWeight.bold 
                                                  : FontWeight.normal, 
                                                  color: Colors.white
                                                ),
                                              ),

                                              subtitle: Text(
                                                'CódBarras: ${product.cdBarras.characters}',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              
                                              onTap: () {
                                                setState(() {
                                                  cadProductModal(context, product: product);
                                                });
                                              },

                                              trailing: isSelected

                                                ? IconButton(
                                                  icon: const Icon(
                                                    Icons.delete, 
                                                    color: Colors.red
                                                  ),

                                                  onPressed: () => _confirmDelete(context, viewModel, product),
                                                  )
                                                : null,
                                            ),
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ProductViewModel viewModel, ProductModel product) {
    showDialog(
      context: context,

      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0x60021D3B),

        title: const Text('Confirmar Exclusão', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18,
          ),
        ),
      
        content: Text('Tem certeza que deseja excluir "${product.nome}"?', 
          style: TextStyle(
            color: Colors.white
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Cancelar', 
              style: TextStyle(color: Colors.white),
            )
          ),

          ElevatedButton(
            onPressed: () async {
              await viewModel.deleteProduct(product);

              if (mounted) {
                Navigator.pop(ctx); // ignore: use_build_context_synchronously
                setState(() => _selectedProduct = null);

                ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                  const SnackBar(
                    content: Text('Produto excluído'), 
                    backgroundColor: Colors.redAccent
                  ),
                );
              }
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            child: const Text('Excluir', style: TextStyle(color: Colors.white)),

          ),
        ],
      ),
    ); 
  }
}