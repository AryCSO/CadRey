import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_modal.dart';
import 'package:cadrey/pages/clientes/ViewModel/client_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ClientCadastroView extends StatefulWidget {
  const ClientCadastroView({super.key});

  @override
  State<ClientCadastroView> createState() => _ClientCadastroViewState();
}

class _ClientCadastroViewState extends State<ClientCadastroView> {
  ClientModel? _selectedClient;
  bool _isCreatingNew = false;

  
  String _formatCpfCnpj(String? value) {
    if (value == null || value.isEmpty) return '';
    
    
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    
    if (numbers.length == 11) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, 11)}';
    }
    
    else if (numbers.length == 14) {
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12, 14)}';
    }
    
    
    return value;
  }

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

                  if (!_isCreatingNew)
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
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Pesquisar Cliente...',
                          hintStyle: const TextStyle(
                            color: Colors.white70
                          ),
                          
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),

                          filled: true,
                          fillColor: const Color(0xFF021D3B),
                          isDense: true,
                        ),

                        style: const TextStyle(
                          color: Colors.white
                        ),

                        onChanged: (value) {},
                      ),
                    ),
                    
                    const Divider(
                      height: 1, 
                      color: Colors.white10
                    ),

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
                                    
                                    final cleanCpf = client.cpf.replaceAll(RegExp(r'[^0-9]'), '');
                                    final isPJ = cleanCpf.length > 11;

                                    return _buildClientCard(
                                      client: client,
                                      isSelected: isSelected,
                                      isPJ: isPJ,
                                      onTap: () {
                                        setState(() {
                                          _selectedClient = client;
                                          _isCreatingNew = false;
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
                                        cadClientModal(context, client: client);
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
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                    backgroundColor: isPJ 
                    ? Colors.orange.shade100
                    : Colors.indigo,

                    child: Icon(
                      isPJ
                      ? Icons.domain 
                      : Icons.person,

                      color: isPJ 
                      ? Colors.orange 
                      : Colors.indigo,
                    ),
                    
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline, 
                      color: Colors.redAccent, 
                      size: 20
                    ),

                    onPressed: onDelete,
                    tooltip: "Excluir",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
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
                  fontSize: 18,
                ),
              ),

              Text(
                '${isPJ 
                  ? "CNPJ" 
                  : "CPF"
                }: ${_formatCpfCnpj(client.cpf)}',
                style: const TextStyle(
                  color: Colors.white70, 
                  fontSize: 13
                ),
              ),
              if (client.cidade.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on, 
                        size: 15, 
                        color: Colors.grey
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          '${client.cidade} - ${client.estado}',
                          overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11
                          ),
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
        title: const Text('Confirmar Exclusão',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )
        ),

        content: Text('Tem certeza que deseja excluir o cadastro: "${client.nome}"?',
          style: const TextStyle(
            color: Colors.white
          )
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', 
              style: TextStyle(
                color: Colors.white
              )
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              await viewModel.deleteClient(client);
              if (mounted) {
                Navigator.pop(ctx); // ignore: use_build_context_synchronously
                setState(() => _selectedClient = null);
                ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                  const SnackBar(
                    content: Text('Cliente excluído.'), 
                    backgroundColor: Colors.redAccent
                  ),
                );
              }
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', 
              style: TextStyle(
                color: Colors.white
              )
            ),
          ),
        ],
      ),
    );
  }
}