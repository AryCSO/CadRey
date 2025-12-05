import 'package:cadrey/viewmodels/client_viewmodel.dart';
import 'package:cadrey/models/dependent_add_modal.dart';
import 'package:cadrey/models/client_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientCadastroView extends StatelessWidget {
  const ClientCadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: const Text(
              'Cadastro de Produtos',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[700],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.clients.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum cliente cadastrado.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : _buildClientList(context, viewModel),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEditClientModal(context, viewModel),
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, color: Colors.white,),
          ),
        );
      },
    );
  }

  Widget _buildClientList(BuildContext context, ClientViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.clients.length,
      itemBuilder: (context, index) {
        final client = viewModel.clients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.shade100,
              child: const Icon(Icons.person, color: Colors.indigo),
            ),
            title: Text(
              client.nome,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('CPF: ${client.cpf} | Cidade: ${client.cidade}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () => _showAddEditClientModal(
                    context,
                    viewModel,
                    client: client,
                  ),
                ),
                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _confirmDelete(context, viewModel, client),
                ),
              ],
            ),
            children: [
              if (client.dependentes != null && client.dependentes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dependentes:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...client.dependentes!.map(
                        (d) => ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 32,
                            right: 16,
                          ),
                          title: Text(d.nome),
                          subtitle: Text(
                            '${d.parentesco} - Nasc: ${DateFormat('dd/MM/yyyy').format(d.dataNascimento)}',
                          ),
                          leading: const Icon(Icons.child_care, size: 20),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  child: Text('Nenhum dependente cadastrado.'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showAddEditClientModal(
    BuildContext context,
    ClientViewModel viewModel, {
    ClientModel? client,
  }) {
    final isEditing = client != null;

    viewModel.clearTempDependents();
    if (isEditing && client.dependentes != null) {
      for (var d in client.dependentes!) {
        viewModel.addTempDependent(
          nome: d.nome,
          parentesco: d.parentesco,
          dataNascimento: d.dataNascimento,
        );
      }
    }

    final formKey = GlobalKey<FormState>();

    final nomeController = TextEditingController(
      text: isEditing ? client.nome : '',
    );
    final cpfController = TextEditingController(
      text: isEditing ? client.cpf : '',
    );
    final dataNascimentoController = TextEditingController(
      text: isEditing
          ? DateFormat('dd/MM/yyyy').format(client.dataNascimento)
          : '',
    );
    final telefoneController = TextEditingController(
      text: isEditing ? client.telefone : '',
    );
    final emailController = TextEditingController(
      text: isEditing ? client.email : '',
    );
    final cepController = TextEditingController(
      text: isEditing ? client.cep : '',
    );
    final logradouroController = TextEditingController(
      text: isEditing ? client.logradouro : '',
    );
    final numeroController = TextEditingController(
      text: isEditing ? client.numero : '',
    );
    final bairroController = TextEditingController(
      text: isEditing ? client.bairro : '',
    );
    final cidadeController = TextEditingController(
      text: isEditing ? client.cidade : '',
    );
    final estadoController = TextEditingController(
      text: isEditing ? client.estado : '',
    );
    final complementoController = TextEditingController(
      text: isEditing ? client.complemento : '',
    );
    final empresaCnpjController = TextEditingController(
      text: isEditing ? client.empresaCnpj : '',
    );
    final cargoController = TextEditingController(
      text: isEditing ? client.cargo : '',
    );

    DateTime? selectedDate = isEditing ? client.dataNascimento : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (innerCtx, setState) {
            return Consumer<ClientViewModel>(
              builder: (consumerCtx, vm, child) {
                if (vm.logradouro.isNotEmpty &&
                    logradouroController.text != vm.logradouro) {
                  if (!vm.logradouro.contains('Erro')) {
                    logradouroController.text = vm.logradouro;
                    bairroController.text = vm.bairro;
                    cidadeController.text = vm.cidade;
                    estadoController.text = vm.estado;
                  }
                }

                if (vm.empresa.isNotEmpty &&
                    cargoController.text != vm.empresa) {
                  cargoController.text = vm.empresa;
                }

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(innerCtx).viewInsets.bottom,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close, color: Colors.blue),
                              ),
                            ],
                          ),
                          Text(
                            isEditing ? client.nome : 'Novo Cliente',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(height: 30),

                          TextFormField(
                            controller: nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                            ),
                            validator: (v) =>
                                v!.isEmpty ? 'Campo obrigatório' : null,
                          ),
                          TextFormField(
                            controller: cpfController,
                            decoration: const InputDecoration(labelText: 'CPF'),
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                v!.isEmpty ? 'Campo obrigatório' : null,
                            enabled: !isEditing,
                          ),

                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: consumerCtx,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                  dataNascimentoController.text = DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(selectedDate!);
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Data de Nascimento',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              isEmpty: dataNascimentoController.text.isEmpty,
                              child: Text(
                                dataNascimentoController.text.isEmpty
                                    ? ''
                                    : dataNascimentoController.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: telefoneController,
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Endereço',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),

                          TextFormField(
                            controller: cepController,
                            decoration: InputDecoration(
                              labelText: 'CEP',
                              suffixIcon:
                                  vm.logradouro == 'Buscando...' ||
                                      vm.logradouro.contains('Deu ruim')
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () =>
                                          vm.searchCep(cepController.text),
                                    ),
                              errorText:
                                  vm.logradouro.contains(
                                        'CEP não encontrado',
                                      ) ||
                                      vm.logradouro.contains('Deu ruim')
                                  ? vm.logradouro
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            controller: logradouroController,
                            decoration: const InputDecoration(
                              labelText: 'Logradouro',
                            ),
                            enabled: vm.logradouro != 'Buscando...',
                          ),
                          TextFormField(
                            controller: numeroController,
                            decoration: const InputDecoration(
                              labelText: 'Número',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            controller: bairroController,
                            decoration: const InputDecoration(
                              labelText: 'Bairro',
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: cidadeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Cidade',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: estadoController,
                                  decoration: const InputDecoration(
                                    labelText: 'UF',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: complementoController,
                            decoration: const InputDecoration(
                              labelText: 'Complemento',
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Dados Empresariais',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),

                          TextFormField(
                            controller: empresaCnpjController,
                            decoration: InputDecoration(
                              labelText: 'CNPJ',
                              suffixIcon: vm.empresa == 'Buscando...'
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.business),
                                      onPressed: () => vm.searchCnpj(
                                        empresaCnpjController.text,
                                      ),
                                    ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            controller: cargoController,
                            decoration: InputDecoration(
                              labelText:
                                  'Empresa ${vm.empresa.isNotEmpty && vm.empresa != 'Buscando...' ? vm.empresa : ''}',
                            ),
                            enabled: vm.empresa != 'Buscando...',
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Dependentes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),

                          ...vm.tempDependentes.map(
                            (d) => ListTile(
                              leading: const Icon(
                                Icons.child_care,
                                color: Colors.indigo,
                              ),
                              title: Text(d.nome),
                              subtitle: Text(d.parentesco),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    vm.removeTempDependent(d.idDependente),
                              ),
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: consumerCtx,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (modalCtx) =>
                                    const DependentAddModal(),
                              );
                            },
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Novo Dependente'),
                          ),

                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isEditing
                                  ? Colors.orange.shade700
                                  : Colors.indigo.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: Text(
                              isEditing ? 'Salvar Alterações' : 'Adicionar',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  selectedDate != null) {
                                final Map<String, dynamic> data = {
                                  'nome': nomeController.text.trim(),
                                  'cpf': cpfController.text.trim(),
                                  'dataNascimento': selectedDate!,
                                  'telefone': telefoneController.text.trim(),
                                  'email': emailController.text.trim(),
                                  'cep': cepController.text.trim(),
                                  'logradouro': logradouroController.text
                                      .trim(),
                                  'numero': numeroController.text.trim(),
                                  'bairro': bairroController.text.trim(),
                                  'cidade': cidadeController.text.trim(),
                                  'estado': estadoController.text.trim(),
                                  'complemento':
                                      complementoController.text.trim().isEmpty
                                      ? null
                                      : complementoController.text.trim(),
                                  'empresaCnpj':
                                      empresaCnpjController.text.trim().isEmpty
                                      ? null
                                      : empresaCnpjController.text.trim(),
                                  'cargo': cargoController.text.trim().isEmpty
                                      ? null
                                      : cargoController.text.trim(),
                                };

                                if (isEditing) {
                                  client.nome = data['nome'] as String;
                                  client.dataNascimento =
                                      data['dataNascimento'] as DateTime;
                                  client.telefone = data['telefone'] as String;
                                  client.email = data['email'] as String;
                                  client.cep = data['cep'] as String;
                                  client.logradouro =
                                      data['logradouro'] as String;
                                  client.numero = data['numero'] as String;
                                  client.bairro = data['bairro'] as String;
                                  client.cidade = data['cidade'] as String;
                                  client.estado = data['estado'] as String;
                                  client.complemento =
                                      data['complemento'] as String?;
                                  client.empresaCnpj =
                                      data['empresaCnpj'] as String?;
                                  client.cargo = data['cargo'] as String?;

                                  client.dependentes = vm.tempDependentes.map((
                                    d,
                                  ) {
                                    d.idCliente = client.idCliente;
                                    return d;
                                  }).toList();

                                  await vm.updateClient(client);
                                } else {
                                  await vm.addNewClient(
                                    nome: data['nome'] as String,
                                    cpf: data['cpf'] as String,
                                    dataNascimento:
                                        data['dataNascimento'] as DateTime,
                                    telefone: data['telefone'] as String,
                                    email: data['email'] as String,
                                    cep: data['cep'] as String,
                                    logradouro: data['logradouro'] as String,
                                    numero: data['numero'] as String,
                                    bairro: data['bairro'] as String,
                                    cidade: data['cidade'] as String,
                                    estado: data['estado'] as String,
                                    complemento: data['complemento'] as String?,
                                    empresaCnpj: data['empresaCnpj'] as String?,
                                    cargo: data['cargo'] as String?,
                                  );
                                }
                              } else if (selectedDate == null) {
                                ScaffoldMessenger.of(consumerCtx).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Data de Nascimento obrigatória.',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ClientViewModel viewModel,
    ClientModel client,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Tem certeza que deseja excluir o cliente "${client.nome}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteClient(client);
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
