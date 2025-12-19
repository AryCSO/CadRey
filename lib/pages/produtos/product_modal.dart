import 'package:cadrey/pages/produtos/Model/product_model.dart';
import 'package:cadrey/pages/produtos/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void cadProductModal(BuildContext context, {ProductModel? product}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF2E2E48),
    isDismissible: true,
    isScrollControlled: true,

    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),

    builder: (context) {
      return CadProductModaltela(
        isCreating: product == null,
        product: product,
        onCancel: () {},
        onSuccess: () {},
      );
    },
  );
}

class CadProductModaltela extends StatefulWidget {
  final ProductModel? product;
  final bool isCreating;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const CadProductModaltela({
    super.key,
    this.product,
    required this.isCreating,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<CadProductModaltela> createState() => _CadProductModaltelaState();
}

class _CadProductModaltelaState extends State<CadProductModaltela> {
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
    cdBarrasController = TextEditingController(text: p?.cdBarras);
    nomeController = TextEditingController(text: p?.nome);
    precoController = TextEditingController(text: p?.preco.toString());
    estoqueController = TextEditingController(text: p?.estoque.toString());
    descricaoController = TextEditingController(text: p?.descricao);
    categoriaController = TextEditingController(text: p?.categoria);
    marcaController = TextEditingController(text: p?.marca);
    pesoController = TextEditingController(text: p?.peso.toString());
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
                horizontal: 28,
                vertical: 14,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF021D3B),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF021D3B)),
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isCreating 
                    ? 'Novo Produto' 
                    : 'Editando Produto',

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      if (!widget.isCreating) ...[
                        IconButton(
                          onPressed: () => _confirmDelete(context, vm),
                          icon: const Icon(
                            Icons.delete_outline, 
                            color: Colors.redAccent
                          ),
                          tooltip: 'Excluir Produto',
                        ),
                        const SizedBox(width: 8),
                        
                      ],

                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                           side: const BorderSide(color: Colors.white54),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
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
                            vertical: 12,
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
                            const Text(
                              "Informações",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Divider(color: Colors.white24),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: cdBarrasController,
                              decoration: const InputDecoration(
                                labelText: 'Código de Barras',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Obrigatório' : null,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: nomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Obrigatório' : null,
                              style: const TextStyle(color: Colors.white),
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
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Estoque & Valores",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Divider(color: Colors.white24),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: precoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Preço',
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    validator: (v) =>
                                        v!.isEmpty ? 'Obrigatório' : null,
                                    style: const TextStyle(color: Colors.white),
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
                                    style: const TextStyle(color: Colors.white),
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
                                      labelStyle: TextStyle(color: Colors.white),
                                    ),
                                    style: const TextStyle(color: Colors.white),
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
                                    style: const TextStyle(color: Colors.white),
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
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: const TextStyle(color: Colors.white),
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

  void _confirmDelete(BuildContext context, ProductViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF021D3B),
        title: Text('Confirmar Exclusão', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 23
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir "${widget.product?.nome}"?', 
          style: const TextStyle(color: Colors.white)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget.product != null) {
                await vm.deleteProduct(widget.product!);
                if (mounted) {
                  Navigator.pop(ctx); // ignore: use_build_context_synchronously
                  Navigator.pop(context); // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                    const SnackBar(
                      content: Text('Produto excluído com sucesso.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  widget.onSuccess();
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
                backgroundColor: Colors.teal,
              ),
            );
            widget.onSuccess();
            Navigator.pop(context);
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
                backgroundColor: Colors.teal,
              ),
            );
            widget.onSuccess();
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}