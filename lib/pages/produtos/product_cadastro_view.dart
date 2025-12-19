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
                vertical: 5,
              ),
              color: Colors.teal[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gestão de Produtos',
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
                          cadProductModal(context);
                        });
                      },
                      label: const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0x0007171b),
                      ),
                    ),
                ],
              ),
            ),

            
            Expanded(
              child: Container(
                color: const Color(0x0007171b),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pesquisar Nome ou Código...',
                          hintStyle: const TextStyle(
                            color: Colors.white70
                          ),
                          prefixIcon: const Icon(
                            Icons.search, 
                            color: Colors.white
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), 
                            borderSide: BorderSide.none
                          ),
                          filled: true,
                          fillColor: const Color(0xFF021D3B),
                          isDense: true,
                        ),
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        onChanged: (query) {
                          viewModel.setSearchQuery(query);
                        },
                      ),
                    ),
                    
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
                                        fontSize: 15
                                      ),
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 240, 
                                    mainAxisExtent: 300,
                                    childAspectRatio: 1.8,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: viewModel.filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = viewModel.filteredProducts[index];
                                    final isSelected = _selectedProduct == product;

                                    return _buildProductCard(
                                      product: product,
                                      isSelected: isSelected,
                                      onTap: () {
                                        setState(() {
                                          cadProductModal(context, product: product);
                                        });
                                      },
                                      onDelete: () => _confirmDelete(context, viewModel, product),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard({
    required ProductModel product,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return SizedBox(
      height: 2,
      width: 2,
    child: Card(
      color: const Color(0xFF2E2E48),
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25), // efeito de gota (Pra ficar bonitin)
        hoverColor: Color(0xFF434372),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/images/akuma.jpg',
                  width: 400,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, 
                      vertical: 4
                    ),
                    decoration: BoxDecoration(
                      color: product.estoque > 0 
                      ? Colors.teal 
                      : Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Estoque: ${product.estoque}',
                      style: TextStyle(
                        color: 
                          product.estoque > 0
                            ? Colors.white 
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline, 
                      color: Colors.redAccent, 
                      size: 25,
                    ),
                    onPressed: onDelete,
                    tooltip: "Excluir",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                ],
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Cód: ${product.cdBarras}',
                    style: const TextStyle(
                      color: Colors.white54, 
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$ ${product.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  if (product.marca.isNotEmpty)
                    Flexible(
                      child: Text(
                        product.marca,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.tealAccent, 
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _confirmDelete(BuildContext context, ProductViewModel viewModel, ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF021D3B),

        title: const Text('Confirmar Exclusão', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),

        content: Text('Tem certeza que deseja excluir "${product.nome}"?', 
          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', 
              style: TextStyle(
                color: Colors.white,
              ),
            ),
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
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red
            ),
            child: const Text('Excluir', 
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}