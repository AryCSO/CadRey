
import 'package:cadrey/pages/Dependentes/dependent_add_modal.dart';
import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientCadastroView extends StatefulWidget {
  const ClientCadastroView({super.key});

  @override
  State<ClientCadastroView> createState() => _ClientCadastroViewState();
}

class _ClientCadastroViewState extends State<ClientCadastroView> {
  // Estado local para controlar qual cliente está sendo editado (ou se é um novo)
  // Se null, nenhum cliente selecionado (estado inicial ou "Novo" não clicado).
  ClientModel? _selectedClient;
  bool _isCreatingNew = false; // Flag para saber se estamos criando um novo

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Gestão de Clientes',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[700],
            actions: [
              // Botão "Novo" na AppBar para Desktop
              if (!_isCreatingNew && _selectedClient == null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedClient = null;
                        _isCreatingNew = true;
                      });
                      viewModel.clearTempDependents(); // Prepara VM para novo
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Novo Cliente"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue[700],
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          body: Row(
            children: [
              // --- PAINEL ESQUERDO: LISTA DE CLIENTES (35% da tela) ---
              Expanded(
                flex: 4, // Proporção da largura
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey.shade300)),
                    color: Colors.grey.shade50,
                  ),
                  child: Column(
                    children: [
                      // Barra de Título/Filtro da Lista
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Pesquisar Cliente...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            // TODO: Implementar filtro na ViewModel
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      // Lista com Scroll Independente
                      Expanded(
                        child: viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : viewModel.clients.isEmpty
                                ? const Center(
                                    child: Text('Nenhum cliente cadastrado.'),
                                  )
                                : ListView.builder(
                                    itemCount: viewModel.clients.length,
                                    itemBuilder: (context, index) {
                                      final client = viewModel.clients[index];
                                      final isSelected = _selectedClient == client;
                                      return Container(
                                        color: isSelected ? Colors.blue.withOpacity(0.1) : null,
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
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${client.cpf.length > 14 ? "CNPJ" : "CPF"}: ${client.cpf}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedClient = client;
                                              _isCreatingNew = false;
                                            });
                                            // Carrega dependentes na VM para edição
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
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () => _confirmDelete(context, viewModel, client),
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

              // --- PAINEL DIREITO: FORMULÁRIO (65% da tela) ---
              Expanded(
                flex: 7,
                child: Container(
                  color: Colors.white,
                  child: (_selectedClient != null || _isCreatingNew)
                      ? _ClientForm(
                          key: ValueKey(_selectedClient?.hashCode ?? 'new'), // Força rebuild ao mudar cliente
                          client: _selectedClient,
                          isCreating: _isCreatingNew,
                          onCancel: () {
                            setState(() {
                              _selectedClient = null;
                              _isCreatingNew = false;
                            });
                          },
                          onSuccess: () {
                            setState(() {
                              _selectedClient = null;
                              _isCreatingNew = false;
                            });
                          },
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.touch_app, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "Selecione um cliente para editar\nou clique em 'Novo Cliente'",
                                style: TextStyle(color: Colors.grey, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
          // Botão flutuante removido, pois a ação "Novo" foi movida para a AppBar ou painel lateral
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ClientViewModel viewModel, ClientModel client) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o cliente "${client.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.deleteClient(client);
              if (mounted) {
                Navigator.pop(ctx);
                setState(() {
                  _selectedClient = null; // Limpa seleção se o deletado era o atual
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente excluído com sucesso.'),
                    backgroundColor: Colors.redAccent,
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

// --- WIDGET DO FORMULÁRIO ISOLADO (Para o Painel Direito) ---
class _ClientForm extends StatefulWidget {
  final ClientModel? client;
  final bool isCreating;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const _ClientForm({
    super.key,
    this.client,
    required this.isCreating,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<_ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<_ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late bool isPessoaJuridica;
  
  // Controllers
  late TextEditingController nomeController;
  late TextEditingController cpfController;
  late TextEditingController cnpjController;
  late TextEditingController dataNascimentoController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;
  late TextEditingController cepController;
  late TextEditingController logradouroController;
  late TextEditingController numeroController;
  late TextEditingController bairroController;
  late TextEditingController cidadeController;
  late TextEditingController estadoController;
  late TextEditingController complementoController;
  late TextEditingController nomeFantasiaController;
  late TextEditingController cargoController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final client = widget.client;
    
    // Define tipo de pessoa inicial
    if (widget.isCreating) {
      isPessoaJuridica = false;
    } else {
      isPessoaJuridica = (client?.cpf.length ?? 0) > 14;
    }

    // Inicializa controllers
    nomeController = TextEditingController(text: client?.nome ?? '');
    cpfController = TextEditingController(text: (!isPessoaJuridica ? client?.cpf : '') ?? '');
    cnpjController = TextEditingController(text: (isPessoaJuridica ? client?.cpf : '') ?? '');
    
    selectedDate = client?.dataNascimento;
    dataNascimentoController = TextEditingController(
      text: selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : '',
    );
    
    telefoneController = TextEditingController(text: client?.telefone ?? '');
    emailController = TextEditingController(text: client?.email ?? '');
    cepController = TextEditingController(text: client?.cep ?? '');
    logradouroController = TextEditingController(text: client?.logradouro ?? '');
    numeroController = TextEditingController(text: client?.numero ?? '');
    bairroController = TextEditingController(text: client?.bairro ?? '');
    cidadeController = TextEditingController(text: client?.cidade ?? '');
    estadoController = TextEditingController(text: client?.estado ?? '');
    complementoController = TextEditingController(text: client?.complemento ?? '');
    nomeFantasiaController = TextEditingController(text: client?.empresaCnpj ?? '');
    cargoController = TextEditingController(text: client?.cargo ?? '');
  }

  @override
  void dispose() {
    // Clean up controllers
    nomeController.dispose();
    cpfController.dispose();
    cnpjController.dispose();
    dataNascimentoController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    cepController.dispose();
    logradouroController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    complementoController.dispose();
    nomeFantasiaController.dispose();
    cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, vm, child) {
        // --- Sincronização de Campos Automáticos (CEP) ---
        if (vm.logradouro.isNotEmpty && logradouroController.text != vm.logradouro) {
          if (!vm.logradouro.contains('Erro') && !vm.logradouro.contains('Buscando')) {
            // Usa addPostFrameCallback para evitar erro de setState durante build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                logradouroController.text = vm.logradouro;
                bairroController.text = vm.bairro;
                cidadeController.text = vm.cidade;
                estadoController.text = vm.estado;
                if (vm.numero.isNotEmpty) numeroController.text = vm.numero;
              }
            });
          }
        }

        // --- Sincronização de Campos Automáticos (CNPJ) ---
        if (vm.nomeRazaoSocial.isNotEmpty && nomeController.text != vm.nomeRazaoSocial) {
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if(mounted) nomeController.text = vm.nomeRazaoSocial;
           });
        }
        if (vm.empresa.isNotEmpty && nomeFantasiaController.text != vm.empresa) {
           if (!vm.empresa.contains('Buscando')) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
               if(mounted) nomeFantasiaController.text = vm.empresa;
             });
           }
        }

        return Column(
          children: [
            // Cabeçalho do Formulário (Fixo no topo do painel direito)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isCreating ? 'Novo Cadastro' : 'Editando Cliente',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.blue[800]
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: widget.onCancel,
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isCreating ? Colors.blue[700] : Colors.orange[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.save),
                        label: Text(widget.isCreating ? 'Salvar' : 'Atualizar'),
                        onPressed: () => _submitForm(vm),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            // Corpo do Formulário com Scroll Próprio
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Row( // DIVIDINDO O FORMULÁRIO EM LADO A LADO
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- COLUNA 1: DADOS PESSOAIS ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- TIPO DE PESSOA ---
                            Center(
                              child: ToggleButtons(
                                isSelected: [!isPessoaJuridica, isPessoaJuridica],
                                onPressed: (index) {
                                  setState(() {
                                    isPessoaJuridica = index == 1;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                selectedColor: Colors.white,
                                fillColor: Colors.blue[700],
                                children: const [
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Física (CPF)")),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Jurídica (CNPJ)")),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            const Text("Dados Principais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const Divider(),
                            const SizedBox(height: 16),
                            
                            // DOCUMENTO
                            if (isPessoaJuridica)
                              TextFormField(
                                controller: cnpjController,
                                decoration: InputDecoration(
                                  labelText: 'CNPJ (Busca Automática)',
                                  suffixIcon: vm.empresa == 'Buscando...'
                                      ? const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.search, color: Colors.blue),
                                          onPressed: () => vm.searchCnpj(cnpjController.text),
                                        ),
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (v) => isPessoaJuridica && (v == null || v.isEmpty) ? 'Obrigatório' : null,
                              )
                            else
                              TextFormField(
                                controller: cpfController,
                                decoration: const InputDecoration(labelText: 'CPF', border: OutlineInputBorder()),
                                validator: (v) => !isPessoaJuridica && (v == null || v.isEmpty) ? 'Obrigatório' : null,
                                enabled: widget.isCreating,
                              ),
                            
                            const SizedBox(height: 16),

                            // NOME
                            TextFormField(
                              controller: nomeController,
                              decoration: InputDecoration(
                                labelText: isPessoaJuridica ? 'Razão Social' : 'Nome Completo',
                                border: const OutlineInputBorder()
                              ),
                              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                            ),
                            
                            const SizedBox(height: 16),

                            // DATA NASCIMENTO E TELEFONE
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          selectedDate = picked;
                                          dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(picked);
                                        });
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: isPessoaJuridica ? 'Data Fundação' : 'Data Nascimento',
                                        border: const OutlineInputBorder(),
                                        suffixIcon: const Icon(Icons.calendar_today),
                                      ),
                                      child: Text(dataNascimentoController.text.isEmpty ? 'Selecione' : dataNascimentoController.text),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: telefoneController,
                                    decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),

                      // Espaçador Central
                      const SizedBox(width: 32),

                      // --- COLUNA 2: ENDEREÇO E DEPENDENTES ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Endereço", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const Divider(),
                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: cepController,
                                    decoration: InputDecoration(
                                      labelText: 'CEP',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => vm.searchCep(cepController.text)),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: logradouroController,
                                    decoration: const InputDecoration(labelText: 'Logradouro', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: numeroController,
                                    decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: bairroController,
                                    decoration: const InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: cidadeController,
                                    decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: estadoController,
                                    decoration: const InputDecoration(labelText: 'UF', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: complementoController,
                              decoration: const InputDecoration(labelText: 'Complemento', border: OutlineInputBorder()),
                            ),

                            const SizedBox(height: 32),
                            const Text("Adicionais & Dependentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                            const Divider(),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: nomeFantasiaController,
                                    decoration: InputDecoration(
                                      labelText: isPessoaJuridica ? 'Nome Fantasia' : 'Empresa',
                                      border: const OutlineInputBorder()
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: cargoController,
                                    decoration: const InputDecoration(labelText: 'Cargo/Obs', border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),

                            if (!isPessoaJuridica) ...[
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Dependentes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => const Dialog(child: DependentAddModal()), // Modal como Dialog no Desktop
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text("Adicionar"),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: vm.tempDependentes.isEmpty 
                                    ? [const Padding(padding: EdgeInsets.all(16.0), child: Text("Nenhum dependente."))]
                                    : vm.tempDependentes.map((d) => ListTile(
                                        leading: const Icon(Icons.child_care),
                                        title: Text(d.nome),
                                        subtitle: Text('${d.parentesco} - ${DateFormat('dd/MM/yyyy').format(d.dataNascimento)}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                          onPressed: () => vm.removeTempDependent(d.idDependente),
                                        ),
                                      )).toList(),
                                ),
                              ),
                            ],
                            // Espaço extra no final
                            const SizedBox(height: 50),
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

  Future<void> _submitForm(ClientViewModel vm) async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final documentoFinal = isPessoaJuridica ? cnpjController.text.trim() : cpfController.text.trim();
      
      try {
        if (widget.isCreating) {
          await vm.addNewClient(
            nome: nomeController.text.trim(),
            cpf: documentoFinal,
            dataNascimento: selectedDate!,
            telefone: telefoneController.text.trim(),
            email: emailController.text.trim(),
            cep: cepController.text.trim(),
            logradouro: logradouroController.text.trim(),
            numero: numeroController.text.trim(),
            bairro: bairroController.text.trim(),
            cidade: cidadeController.text.trim(),
            estado: estadoController.text.trim(),
            complemento: complementoController.text.trim().isEmpty ? null : complementoController.text.trim(),
            empresaCnpj: nomeFantasiaController.text.trim().isEmpty ? null : nomeFantasiaController.text.trim(),
            cargo: cargoController.text.trim().isEmpty ? null : cargoController.text.trim(),
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cliente criado com sucesso!"), backgroundColor: Colors.green));
            widget.onSuccess();
          }
        } else {
          // Edição
          final client = widget.client!;
          client.nome = nomeController.text.trim();
          client.cpf = documentoFinal;
          client.dataNascimento = selectedDate!;
          client.telefone = telefoneController.text.trim();
          client.email = emailController.text.trim();
          client.cep = cepController.text.trim();
          client.logradouro = logradouroController.text.trim();
          client.numero = numeroController.text.trim();
          client.bairro = bairroController.text.trim();
          client.cidade = cidadeController.text.trim();
          client.estado = estadoController.text.trim();
          client.complemento = complementoController.text.trim().isEmpty ? null : complementoController.text.trim();
          client.empresaCnpj = nomeFantasiaController.text.trim().isEmpty ? null : nomeFantasiaController.text.trim();
          client.cargo = cargoController.text.trim().isEmpty ? null : cargoController.text.trim();
          
          client.dependentes = vm.tempDependentes.map((d) {
            d.idCliente = client.idCliente;
            return d;
          }).toList();

          await vm.updateClient(client);
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cliente atualizado com sucesso!"), backgroundColor: Colors.green));
            widget.onSuccess();
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao salvar: $e"), backgroundColor: Colors.red));
      }
    } else if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data obrigatória"), backgroundColor: Colors.red));
    }
  }
}