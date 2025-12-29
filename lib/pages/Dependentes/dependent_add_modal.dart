import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/ViewModel/client_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void cadDependentModal(BuildContext context, {ClientModel? dependente}) {
  showModalBottomSheet(
    context: context,
    
    backgroundColor: const Color(0xFF2E2E48),
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return const DependentAddModal();
    },
  );
}

class DependentAddModal extends StatelessWidget {
  const DependentAddModal({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClientViewModel>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    final nomeController = TextEditingController();
    final parentescoController = TextEditingController();
    final dataNascimentoController = TextEditingController();
    
    
    
    DateTime? selectedDate;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        
        Future<void> selectDate() async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now(),
          );

          if (picked != null) {
            setState(() {
              selectedDate = picked;
              dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
            });
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    const Text(
                      'Novo Dependente',
                      style: TextStyle(
                        fontSize: 20,
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
                          onPressed: () {
                            if (formKey.currentState!.validate() && selectedDate != null) {
                              viewModel.addTempDependent(
                                nome: nomeController.text.trim(),
                                parentesco: parentescoController.text.trim(),
                                dataNascimento: selectedDate!,
                              );
                              Navigator.pop(context);
                            } else if (selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('A data de nascimento é obrigatória.'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 18),
                          label: const Text('Adicionar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dados do Dependente",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 16),

                        
                        TextFormField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome Completo',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                        ),
                        
                        const SizedBox(height: 16),

                        
                        TextFormField(
                          controller: parentescoController,
                          decoration: const InputDecoration(
                            labelText: 'Parentesco (Ex: Filho, Cônjuge)',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                        ),

                        const SizedBox(height: 16),

                        
                        InkWell(
                          onTap: selectDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Data de Nascimento',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(color: Colors.white),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                            child: Text(
                              dataNascimentoController.text.isEmpty
                                  ? 'Selecione'
                                  : dataNascimentoController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}