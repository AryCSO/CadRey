import 'package:cadrey/pages/Dependentes/dependent_add_modal.dart';
import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


void cadClientModal(BuildContext context, {ClientModel? client}) {
  showModalBottomSheet(
    context: context,
    
    backgroundColor: const Color(0xFF2E2E48),
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return CadClientModalbox(
        isCreating: client == null, 
        client: client,
        onCancel: () {},
        onSuccess: () {},
      );
    },
  );
}

class CadClientModalbox extends StatefulWidget {
  final bool isCreating;
  final ClientModel? client;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const CadClientModalbox({
    super.key,
    this.client,
    required this.onCancel,
    required this.onSuccess,
    required this.isCreating,
  });

  @override
  State<CadClientModalbox> createState() => _CadClientModalboxState();
}

class _CadClientModalboxState extends State<CadClientModalbox> {
  final _formKey = GlobalKey<FormState>();
  late bool isPessoaJuridica;
  
  
  late TextEditingController cpfController;
  late TextEditingController cepController;
  late TextEditingController nomeController;
  late TextEditingController cnpjController;
  late TextEditingController cargoController;
  late TextEditingController emailController;
  late TextEditingController numeroController;
  late TextEditingController bairroController;
  late TextEditingController cidadeController;
  late TextEditingController estadoController;
  late TextEditingController telefoneController;
  late TextEditingController logradouroController;
  late TextEditingController complementoController;
  late TextEditingController nomeFantasiaController;
  late TextEditingController dataNascimentoController;
  
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final client = widget.client;

    if (widget.isCreating) {
      isPessoaJuridica = false;
    } else {
      isPessoaJuridica = (client?.cpf.length ?? 0) > 14;
    }

    
    nomeController = TextEditingController(text: client?.nome ?? '');
    cpfController = TextEditingController(text: (!isPessoaJuridica ? client?.cpf : '') ?? '');
    cnpjController = TextEditingController(text: (isPessoaJuridica ? client?.cpf : '') ?? '');

    selectedDate = client?.dataNascimento;

    dataNascimentoController = TextEditingController(
      text: selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
          : '',
    );

    cepController = TextEditingController(text: client?.cep ?? '');
    emailController = TextEditingController(text: client?.email ?? '');
    cargoController = TextEditingController(text: client?.cargo ?? '');
    numeroController = TextEditingController(text: client?.numero ?? '');
    bairroController = TextEditingController(text: client?.bairro ?? '');
    cidadeController = TextEditingController(text: client?.cidade ?? '');
    estadoController = TextEditingController(text: client?.estado ?? '');
    telefoneController = TextEditingController(text: client?.telefone ?? '');
    logradouroController = TextEditingController(text: client?.logradouro ?? '');
    complementoController = TextEditingController(text: client?.complemento ?? '');
    nomeFantasiaController = TextEditingController(text: client?.empresaCnpj ?? '');
  }

  @override
  void dispose() {
    cpfController.dispose();
    cepController.dispose();
    nomeController.dispose();
    cnpjController.dispose();
    emailController.dispose();
    cargoController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    telefoneController.dispose();
    logradouroController.dispose();
    complementoController.dispose();
    nomeFantasiaController.dispose();
    dataNascimentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, vm, child) {
        
        
        if (vm.logradouro.isNotEmpty && logradouroController.text != vm.logradouro) {
          if (!vm.logradouro.contains('Deu ruim') && !vm.logradouro.contains('Buscando')) {
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

        if (vm.nomeRazaoSocial.isNotEmpty && nomeController.text != vm.nomeRazaoSocial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) nomeController.text = vm.nomeRazaoSocial;
          });
        }

        if (vm.empresa.isNotEmpty && nomeFantasiaController.text != vm.empresa) {
          if (!vm.empresa.contains('Buscando')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) nomeFantasiaController.text = vm.empresa;
            });
          }
        }

        return Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
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
                    widget.isCreating ? 'Novo Cadastro' : 'Editando Cliente',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
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
                              ? Colors.blue[700]
                              : Colors.orange[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
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

            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWideScreen = constraints.maxWidth > 800;

                      if (isWideScreen) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildPersonalDataFields(
                                setState: setState,
                                isPessoaJuridica: isPessoaJuridica,
                                isEditing: !widget.isCreating,
                                vm: vm,
                                context: context,
                                selectedDate: selectedDate,
                                cpfController: cpfController,
                                cnpjController: cnpjController,
                                nomeController: nomeController,
                                emailController: emailController,
                                telefoneController: telefoneController,
                                dataNascimentoController: dataNascimentoController,
                                onTypeChanged: (bool value) {
                                  setState(() => isPessoaJuridica = value);
                                },
                                onDateChanged: (DateTime date) {
                                  setState(() {
                                    selectedDate = date;
                                    dataNascimentoController.text =
                                        DateFormat('dd/MM/yyyy').format(date);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildAddressAndDependentFields(
                                vm: vm,
                                context: context,
                                cepController: cepController,
                                cargoController: cargoController,
                                numeroController: numeroController,
                                bairroController: bairroController,
                                cidadeController: cidadeController,
                                estadoController: estadoController,
                                isPessoaJuridica: isPessoaJuridica,
                                logradouroController: logradouroController,
                                complementoController: complementoController,
                                nomeFantasiaController: nomeFantasiaController,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildPersonalDataFields(
                              setState: setState,
                              isPessoaJuridica: isPessoaJuridica,
                              isEditing: !widget.isCreating,
                              vm: vm,
                              context: context,
                              selectedDate: selectedDate,
                              cpfController: cpfController,
                              cnpjController: cnpjController,
                              nomeController: nomeController,
                              emailController: emailController,
                              telefoneController: telefoneController,
                              dataNascimentoController: dataNascimentoController,
                              onTypeChanged: (bool value) {
                                setState(() => isPessoaJuridica = value);
                              },
                              onDateChanged: (DateTime date) {
                                setState(() {
                                  selectedDate = date;
                                  dataNascimentoController.text =
                                      DateFormat('dd/MM/yyyy').format(date);
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            const Divider(thickness: 2, color: Colors.white24),
                            const SizedBox(height: 20),
                            _buildAddressAndDependentFields(
                              vm: vm,
                              context: context,
                              cepController: cepController,
                              cargoController: cargoController,
                              numeroController: numeroController,
                              bairroController: bairroController,
                              cidadeController: cidadeController,
                              estadoController: estadoController,
                              isPessoaJuridica: isPessoaJuridica,
                              logradouroController: logradouroController,
                              complementoController: complementoController,
                              nomeFantasiaController: nomeFantasiaController,
                            ),
                          ],
                        );
                      }
                    },
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
      final documentoFinal = isPessoaJuridica
          ? cnpjController.text.trim()
          : cpfController.text.trim();

      try {
        if (widget.isCreating) {
          await vm.addNewClient(
            cpf: documentoFinal,
            dataNascimento: selectedDate!,
            cep: cepController.text.trim(),
            nome: nomeController.text.trim(),
            email: emailController.text.trim(),
            numero: numeroController.text.trim(),
            bairro: bairroController.text.trim(),
            cidade: cidadeController.text.trim(),
            estado: estadoController.text.trim(),
            telefone: telefoneController.text.trim(),
            logradouro: logradouroController.text.trim(),
            cargo: cargoController.text.trim().isEmpty
                ? null
                : cargoController.text.trim(),
            complemento: complementoController.text.trim().isEmpty
                ? null
                : complementoController.text.trim(),
            empresaCnpj: nomeFantasiaController.text.trim().isEmpty
                ? null
                : nomeFantasiaController.text.trim(),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Cadastro criado"),
                backgroundColor: Colors.green,
              ),
            );
            widget.onSuccess();
            Navigator.pop(context);
          }
        } else {
          final client = widget.client!;
          client.cpf = documentoFinal;
          client.dataNascimento = selectedDate!;
          client.cep = cepController.text.trim();
          client.nome = nomeController.text.trim();
          client.email = emailController.text.trim();
          client.numero = numeroController.text.trim();
          client.bairro = bairroController.text.trim();
          client.cidade = cidadeController.text.trim();
          client.estado = estadoController.text.trim();
          client.telefone = telefoneController.text.trim();
          client.logradouro = logradouroController.text.trim();
          client.cargo = cargoController.text.trim().isEmpty
              ? null
              : cargoController.text.trim();
          client.complemento = complementoController.text.trim().isEmpty
              ? null
              : complementoController.text.trim();
          client.empresaCnpj = nomeFantasiaController.text.trim().isEmpty
              ? null
              : nomeFantasiaController.text.trim();

          
          client.dependentes = vm.tempDependentes.map((d) {
            d.idCliente = client.idCliente;
            return d;
          }).toList();

          await vm.updateClient(client);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Cadastro atualizado"),
                backgroundColor: Colors.green,
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
              content: Text("Erro ao salvar: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data obrigatória"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPersonalDataFields({
    required bool isEditing,
    required ClientViewModel vm,
    required StateSetter setState,
    required BuildContext context,
    required bool isPessoaJuridica,
    required DateTime? selectedDate,
    required Function(bool) onTypeChanged,
    required Function(DateTime) onDateChanged,
    required TextEditingController cpfController,
    required TextEditingController cnpjController,
    required TextEditingController nomeController,
    required TextEditingController emailController,
    required TextEditingController telefoneController,
    required TextEditingController dataNascimentoController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ToggleButtons(
            isSelected: [!isPessoaJuridica, isPessoaJuridica],
            onPressed: (index) => onTypeChanged(index == 1),
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: Colors.blue[700],
            color: Colors.white70,
            constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
            children: const [
              Text("CPF", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("CNPJ", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Dados Pessoais",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(color: Colors.white24),
        if (isPessoaJuridica)
          TextFormField(
            controller: cnpjController,
            decoration: InputDecoration(
              labelText: 'CNPJ',
              border: const OutlineInputBorder(),
              suffixIcon: vm.empresa == 'Buscando...'
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () => vm.searchCnpj(cnpjController.text),
                    ),
              labelStyle: const TextStyle(color: Colors.white),
            ),
            validator: (v) => isPessoaJuridica && (v == null || v.isEmpty)
                ? 'Obrigatório'
                : null,
            style: const TextStyle(color: Colors.white),
          )
        else
          TextFormField(
            controller: cpfController,
            decoration: const InputDecoration(
              labelText: 'CPF',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Colors.white),
            ),
            validator: (v) => !isPessoaJuridica && (v == null || v.isEmpty)
                ? 'Obrigatório'
                : null,
            enabled: !isEditing,
            style: const TextStyle(color: Colors.white),
          ),
        const SizedBox(height: 15),
        TextFormField(
          controller: nomeController,
          decoration: InputDecoration(
              labelText: isPessoaJuridica ? 'Razão Social' : 'Nome Completo',
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(color: Colors.white)),
          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1800),
              lastDate: DateTime.now(),
            );
            if (picked != null) onDateChanged(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText:
                  isPessoaJuridica ? 'Data Fundação' : 'Data Nascimento',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              labelStyle: const TextStyle(color: Colors.white),
            ),
            child: Text(
              dataNascimentoController.text.isEmpty
                  ? 'Selecione'
                  : dataNascimentoController.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: telefoneController,
          decoration: const InputDecoration(
            labelText: 'Telefone',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildAddressAndDependentFields({
    required ClientViewModel vm,
    required BuildContext context,
    required bool isPessoaJuridica,
    required TextEditingController cepController,
    required TextEditingController cargoController,
    required TextEditingController numeroController,
    required TextEditingController bairroController,
    required TextEditingController cidadeController,
    required TextEditingController estadoController,
    required TextEditingController logradouroController,
    required TextEditingController complementoController,
    required TextEditingController nomeFantasiaController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Endereço & Detalhes",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(color: Colors.white24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: cepController,
                decoration: InputDecoration(
                  labelText: 'CEP',
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () => vm.searchCep(cepController.text),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: logradouroController,
                decoration: const InputDecoration(
                    labelText: 'Logradouro',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(
                    labelText: 'Número',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(
                  labelText: 'UF',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: complementoController,
          decoration: const InputDecoration(
            labelText: 'Complemento',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        if (!isPessoaJuridica) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Dependentes",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        const Dialog(child: DependentAddModal()),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text("Adicionar",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          if (vm.tempDependentes.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                
                border: Border.all(color: const Color(0xFF5F5FA7)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: vm.tempDependentes
                    .map(
                      (d) => ListTile(
                        title: Text(
                          d.nome,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          d.parentesco,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              vm.removeTempDependent(d.idDependente),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ],
    );
  }
}