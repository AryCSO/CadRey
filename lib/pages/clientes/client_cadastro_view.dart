import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_modal.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ClientCadastroView extends StatefulWidget {
  const ClientCadastroView({super.key});

  @override
  State<ClientCadastroView> createState() => _ClientCadastroViewState();
}

class _ClientCadastroViewState extends State<ClientCadastroView> {
  ClientModel? _selectedClient;
  final bool _isCreatingNew = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              color: Colors.blue[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gestão de Clientes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!_isCreatingNew && _selectedClient == null)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          cadClientModal(context);
                        });
                        viewModel.clearTempDependents();
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
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pesquisar Cliente...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF021D3B),
                          isDense: true,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          
                        },
                      ),
                    ),
                    
                    const Divider(height: 1, color: Colors.white10),

                    Expanded(
                      child: viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : viewModel.clients.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum cliente cadastrado.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300, 
                                    childAspectRatio: 1.2, 
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: viewModel.clients.length,
                                  itemBuilder: (context, index) {
                                    final client = viewModel.clients[index];
                                    final isSelected = _selectedClient == client;
                                    final isPJ = client.cpf.length > 14;

                                    return _buildClientCard(
                                      client: client,
                                      isSelected: isSelected,
                                      isPJ: isPJ,
                                      onTap: () {
                                        setState(() {
                                          cadClientModal(context, client: client);
                                        });

                                        viewModel.clearTempDependents();
                                        if (client.dependentes != null) {
                                          for (var d in client.dependentes!) {
                                            viewModel.addTempDependent(
                                              nome: d.nome,
                                              parentesco: d.parentesco,
                                              dataNascimento: d.dataNascimento,
                                            );
                                          }
                                        }
                                      },
                                      onDelete: () => _confirmDelete(context, viewModel, client),
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

  Widget _buildClientCard({
    required ClientModel client,
    required bool isSelected,
    required bool isPJ,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Card(
      color: const Color(0xFF2E2E48),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
            ? const BorderSide(color: Colors.blueAccent, width: 2) 
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        hoverColor: Color(0xFF434372),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: isPJ ? Colors.orange.shade100 : Colors.indigo.shade100,
                    child: Icon(
                      isPJ ? Icons.domain : Icons.person,
                      color: isPJ ? Colors.orange : Colors.indigo,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                    tooltip: "Excluir",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                client.nome,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isPJ ? "CNPJ" : "CPF"}: ${client.cpf}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (client.cidade.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${client.cidade} - ${client.estado}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ClientViewModel viewModel, ClientModel client) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF021D3B),
        title: Text('Confirmar Exclusão', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 23
          )
        ),
        content: Text('Tem certeza que deseja excluir "${client.nome}"?', 
          style: const TextStyle(
            color: Colors.white
          )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', 
            style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.deleteClient(client);
              if (mounted) {
                Navigator.pop(ctx); // ignore: use_build_context_synchronously
                setState(() => _selectedClient = null);
                ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                  const SnackBar(content: Text('Cliente excluído.'), backgroundColor: Colors.redAccent),
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