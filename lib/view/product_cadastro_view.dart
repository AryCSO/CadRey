import 'package:cadrey/viewmodels/product_viewmodel.dart';
import 'package:cadrey/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProductCadastroView extends StatelessWidget {
  const ProductCadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: (Colors.white)),
            title: const Text(
              'Cadastro de Produtos',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),

                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar Nome ou Código de Barras...',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) {
                    viewModel.setSearchQuery(query);
                  },
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    viewModel.products.isEmpty
                        ? 'Nenhum produto cadastrado'
                        : 'Nenhum resoltado cadastrado para a pesquisa "${viewModel.searchQuery}"',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : _buildProductList(context, viewModel),
            floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEditProductModal(context, viewModel),
            backgroundColor: Colors.teal,
            child: Icon(Icons.add, color: Colors.white,),
          ),
        );
      },
    );
  }

  Widget _buildProductList(BuildContext context, ProductViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = viewModel.filteredProducts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                product.estoque.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              product.nome,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Cód: ${product.cdBarras} | Preço: R\$ ${product.preco.toStringAsFixed(2)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  onPressed: () => _showAddEditProductModal(
                    context,
                    viewModel,
                    product: product,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, viewModel, product),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddEditProductModal(
    BuildContext context,
    ProductViewModel viewModel, {
    ProductModel? product,
  }) {
    final isEditing = product != null;

    final cdBarrasController = TextEditingController(
      text: isEditing ? product.cdBarras : '',
    );
    final nomeController = TextEditingController(
      text: isEditing ? product.nome : '',
    );
    final precoController = TextEditingController(
      text: isEditing ? product.preco.toString() : '',
    );
    final estoqueController = TextEditingController(
      text: isEditing ? product.estoque.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isEditing ? 'Editar Produto' : 'Novo Produto',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Produto',
                  ),
                ),
                TextField(
                  controller: cdBarrasController,
                  decoration: const InputDecoration(
                    labelText: 'Código de Barras',
                  ),
                  keyboardType: TextInputType.number,
                  enabled: !isEditing,
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                TextField(
                  controller: estoqueController,
                  decoration: const InputDecoration(
                    labelText: 'Estoque Inicial',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Icon(Icons.save, color: Colors.white, size: 20),
                  onPressed: () async {
                    final newNome = nomeController.text.trim();
                    final newPreco =
                        double.tryParse(precoController.text) ?? 0.0;
                    final newEstoque =
                        int.tryParse(estoqueController.text) ?? 0;

                    if (isEditing) {
                      product.nome = newNome;
                      product.preco = newPreco;
                      product.estoque = newEstoque;

                      await viewModel.updateProduct(product);
                    } else {
                      await viewModel.addNewProduct(
                        cdBarras: cdBarrasController.text.trim(),
                        nome: newNome,
                        preco: newPreco,
                        estoque: newEstoque,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ProductViewModel viewModel,
    ProductModel product,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Tem certeza que deseja excluir o produto "${product.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteProduct(product);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
