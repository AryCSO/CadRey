import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_modal.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    MaterialApp(
    debugShowCheckedModeBanner: false,

    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate, 
    ],

    supportedLocales: [const Locale('pt', 'BR')],
  );

    return Consumer<ClientViewModel>(
      builder: (context, viewModel, child) {
        
        return Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, 
                vertical: 5
              ),
              color: Colors.blue[700],

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gestão de Clientes',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
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
                        border: Border(
                          right: BorderSide(
                            color: Color(0x0007171b)
                          )
                        ),

                        color: Color(0x0007171b),

                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),

                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pesquisar Cliente...',
                                hintStyle: TextStyle(color: Colors.white),

                                prefixIcon: const Icon(
                                  Icons.search, 
                                  color: Colors.white,
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                filled: true,

                                fillColor: Color(0x0007171b),

                                isDense: true,
                              ),

                              onChanged: (value) {},
                            ),
                          ),

                          const Divider(height: 1),
                          
                          Expanded(
                            child: viewModel.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : viewModel.clients.isEmpty
                                  ? const Center(
                                    child: Text('Nenhum cliente cadastrado.', 
                                      style: TextStyle(color: Colors.grey,)
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: viewModel.clients.length,

                                    itemBuilder: (context, index) {
                                      final client = viewModel.clients[index];
                                      final isSelected = _selectedClient == client;

                                      return Container(

                                        color: isSelected ? Colors.blue : null,

                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: client.cpf.length > 14
                                              ? Colors.orange.shade100
                                              : Colors.indigo.shade100,

                                            child: Icon(
                                              client.cpf.length > 14
                                                  ? Icons.domain
                                                  : Icons.person,
                                              color: client.cpf.length > 14
                                                  ? Colors.orange
                                                  : Colors.indigo,
                                              size: 20,
                                            ),
                                          ),

                                          title: Text(
                                            client.nome,

                                            style: TextStyle(
                                              fontWeight: isSelected 
                                              ? FontWeight.bold 
                                              : FontWeight.normal, 
                                              color: Colors.white
                                            ),
                                          ),

                                          subtitle: Text(
                                            '${client.cpf.length > 14 
                                                ? "CNPJ" 
                                                : "CPF"
                                              }: ${client.cpf}',
                                            
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white),
                                          ),

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

                                            trailing: isSelected

                                            ? IconButton(
                                              icon: const Icon(
                                                Icons.delete, 
                                                color: Colors.red
                                              ),
                                              onPressed: () => _confirmDelete(context, viewModel, client),
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
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context, 
    ClientViewModel viewModel,

    ClientModel client) {
      showDialog(
        context: context,

        builder: (ctx) => AlertDialog(
          backgroundColor: Color(0x60021D3B),
          title: const Text('Confirmar Exclusão', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18
          )
        ),

        content: Text('Tem certeza que deseja excluir o cliente "${client.nome}"?', 
          style: TextStyle(color: Colors.white),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', 
              style: TextStyle(color: Colors.white),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              await viewModel.deleteClient(client);

              if (mounted) {
                Navigator.pop(ctx); // ignore: use_build_context_synchronously

                setState(() {
                  _selectedClient = null; 
                });

                ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                  const SnackBar(
                    content: Text('Cliente excluído.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', 
              style: TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}
