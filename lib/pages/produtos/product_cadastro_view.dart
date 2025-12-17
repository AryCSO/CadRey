import 'package:cadrey/pages/produtos/Model/product_model.dart';
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
  bool _isCreatingNew = false;

  @override
  Widget build(BuildContext context) {

    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, 
                vertical: 12
              ),
              color: Colors.teal[700],

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text('Gestão de Produtos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  if (!_isCreatingNew && _selectedProduct == null)

                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedProduct = null;
                          _isCreatingNew = true;
                        });
                      },

                      label: const Icon(Icons.add, size: 18),

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
                                            color: isSelected ? Colors.teal : null,

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
                                                  _selectedProduct = product;
                                                  _isCreatingNew = false;
                                                });
                                              },

                                              trailing: isSelected

                                                ? IconButton(
                                                  icon: const Icon(
                                                    Icons.delete, 
                                                    color: Colors.red
                                                  ),

                                                  onPressed: () => _confirmDelete(context, viewModel, product),
                                                  ): null,
                                            ),
                                          );
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 7,

                    child: Container(
                      color: Color(0x0007171b),
                      child: (_selectedProduct != null || _isCreatingNew)

                        ? _ProductForm(
                          key: ValueKey(_selectedProduct?.hashCode ?? 'new'),
                          product: _selectedProduct,
                          isCreating: _isCreatingNew,

                          onCancel: () {
                            setState(() {
                            _selectedProduct = null;
                            _isCreatingNew = false;
                            });
                          },

                          onSuccess: () {
                            setState(() {
                              _selectedProduct = null;
                              _isCreatingNew = false;
                            });
                          },
                        )

                        : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                Icons.inventory_outlined, 
                                size: 64, 
                                color: Colors.grey
                              ),

                              SizedBox(height: 16),

                              Text("Selecione um produto para editar\nou clique em  +  para adicionar",
                                style: TextStyle(
                                  color: Colors.grey, 
                                  fontSize: 18
                                ),

                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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

class _ProductForm extends StatefulWidget {
  final ProductModel? product;
  final bool isCreating;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const _ProductForm({
    super.key,
    this.product,
    required this.isCreating,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController cdBarrasController;
  late TextEditingController nomeController;
  late TextEditingController precoController;
  late TextEditingController estoqueController;
  late TextEditingController descricaoController;
  late TextEditingController categoriaController;
  late TextEditingController marcaController;
  late TextEditingController pesoController;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    cdBarrasController = TextEditingController(text: p?.cdBarras ?? '');
    nomeController = TextEditingController(text: p?.nome ?? '');
    precoController = TextEditingController(text: p?.preco.toString() ?? '');
    estoqueController = TextEditingController(text: p?.estoque.toString() ?? '');
    descricaoController = TextEditingController(text: p?.descricao ?? '');
    categoriaController = TextEditingController(text: p?.categoria ?? '');
    marcaController = TextEditingController(text: p?.marca ?? '');
    pesoController = TextEditingController(text: p?.peso.toString() ?? '');
  }

  @override
  void dispose() {
    cdBarrasController.dispose();
    nomeController.dispose();
    precoController.dispose();
    estoqueController.dispose();
    descricaoController.dispose();
    categoriaController.dispose();
    marcaController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24, 
                vertical: 16
              ),

              decoration: BoxDecoration(
                color: Color(0x60021D3B),
                border: Border(bottom: BorderSide(color: Color(0x0007171b))),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    widget.isCreating 
                    ? 'Novo Produto' 
                    : 'Editando Produto',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),

                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: widget.onCancel, 

                        child: const Text('Cancelar', 
                          style: TextStyle(
                            color: Colors.white
                          ),
                        )
                      ),

                      const SizedBox(width: 12),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isCreating 
                          ? Colors.teal[700] 
                          : Colors.orange[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 12
                          ),
                        ),

                        icon: const Icon(Icons.save),
                        label: Text(widget.isCreating 
                          ? 'Salvar' 
                          : 'Atualizar'
                        ),

                        onPressed: () => _submitForm(vm),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text("Informações", 
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              )
                            ),

                            const Divider(),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: cdBarrasController,

                              decoration: const InputDecoration(
                                labelText: 'Código de Barras', 
                                border: OutlineInputBorder(), 
                                labelStyle: TextStyle(color: Colors.white)

                              ),

                              validator: (v) => v!.isEmpty 
                              ? 'Obrigatório' 
                              : null,

                              enabled: widget.isCreating,

                              style: TextStyle(color: Colors.white),
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: nomeController,

                              decoration: const InputDecoration(
                                labelText: 'Nome', 
                                border: OutlineInputBorder(), 
                                labelStyle: TextStyle(color: Colors.white)
                              ),

                              validator: (v) => v!.isEmpty 
                              ? 'Obrigatório' 
                              : null,

                              style: TextStyle(color: Colors.white),
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: descricaoController,

                              decoration: const InputDecoration(
                                labelText: 'Descrição', 
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.white),
                              ),

                              maxLines: 3,

                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 32),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text("Estoque & Valores", 
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              )
                            ),

                            const Divider(),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: precoController,

                                    decoration: const InputDecoration(
                                      labelText: 'Preço', 
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(color: Colors.white)
                                    ),

                                    keyboardType: TextInputType.number,

                                    validator: (v) => v!.isEmpty 
                                    ? 'Obrigatório' 
                                    : null,

                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: TextFormField(
                                    controller: estoqueController,

                                    decoration: const InputDecoration(
                                      labelText: 'Estoque', 
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),

                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: categoriaController,

                                    decoration: const InputDecoration(
                                      labelText: 'Categoria', 
                                      border: OutlineInputBorder(), 
                                      labelStyle: TextStyle(color: Colors.white,)
                                    ),

                                    style: TextStyle(color: Colors.white),

                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: TextFormField(
                                    controller: marcaController,

                                    decoration: const InputDecoration(
                                      labelText: 'Marca', 
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),

                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: pesoController,

                              decoration: const InputDecoration(
                                labelText: 'Peso', 
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.white)
                              ),

                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm(ProductViewModel vm) async {
    if (_formKey.currentState!.validate()) {
      try {
        final newNome = nomeController.text.trim();
        final newPreco = double.tryParse(precoController.text.replaceAll(',', '.')) ?? 0.0;
        final newEstoque = int.tryParse(estoqueController.text) ?? 0;
        final newDescricao = descricaoController.text.trim();
        final newCategoria = categoriaController.text.trim();
        final newMarca = marcaController.text.trim();
        final newPeso = double.tryParse(pesoController.text.replaceAll(',', '.')) ?? 0.0;

        if (widget.isCreating) {
          await vm.addNewProduct(
            cdBarras: cdBarrasController.text.trim(),
            nome: newNome,
            preco: newPreco,
            estoque: newEstoque,
            descricao: newDescricao,
            categoria: newCategoria,
            marca: newMarca,
            peso: newPeso,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Produto criado"), 
                backgroundColor: Colors.teal
              )
            );

            widget.onSuccess();
          }
        } else {
          final product = widget.product!;
          product.nome = newNome;
          product.preco = newPreco;
          product.estoque = newEstoque;
          product.descricao = newDescricao;
          product.categoria = newCategoria;
          product.marca = newMarca;
          product.peso = newPeso;

          await vm.updateProduct(product);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Produto atualizado"), 
                backgroundColor: Colors.teal
              )
            );

            widget.onSuccess();
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
          SnackBar(
            content: Text("Erro: $e"), 
            backgroundColor: Colors.red
          )
        );
      }
    }
  }
}