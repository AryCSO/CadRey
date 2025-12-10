import 'package:cadrey/pages/clientes/client_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Novo Dependente',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),

                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                  TextFormField(
                    controller: parentescoController,
                    decoration: const InputDecoration(labelText: 'Parentesco'),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),

                  InkWell(
                    onTap: selectDate,
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
                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          selectedDate != null) {
                        viewModel.addTempDependent(
                          nome: nomeController.text.trim(),
                          parentesco: parentescoController.text.trim(),
                          dataNascimento: selectedDate!,
                        );
                        Navigator.pop(context);
                      } else if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'A data de nascimento do dependente é obrigatória.',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    label: const Icon(Icons.add_circle, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
