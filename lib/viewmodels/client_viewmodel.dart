import 'package:cadrey/services/client_service.dart';
import 'package:cadrey/models/client_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

const uuid = Uuid();

class ClientViewModel extends ChangeNotifier {
  final ClientService _clientService;
  List<ClientModel> _clients = [];
  bool _isLoading = false;

  String _logradouro = '';
  String _bairro = '';
  String _cidade = '';
  String _estado = '';
  String _empresa = '';

  List<DependentModel> _tempDependentes = [];

  List<ClientModel> get clients => _clients;
  bool get isLoading => _isLoading;
  String get logradouro => _logradouro;
  String get bairro => _bairro;
  String get cidade => _cidade;
  String get estado => _estado;
  String get empresa => _empresa;
  List<DependentModel> get tempDependentes => _tempDependentes;

  ClientViewModel(this._clientService);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearAddressFields() {
    _logradouro = '';
    _bairro = '';
    _cidade = '';
    _estado = '';
    notifyListeners();
  }

  void _clearCnpjFields() {
    _empresa = '';
    notifyListeners();
  }

  void clearTempDependents() {
    _tempDependentes = [];
    notifyListeners();
  }

  void addTempDependent({
    required String nome,
    required String parentesco,
    required DateTime dataNascimento,
  }) {
    final newDependent = DependentModel(
      idDependente: uuid.v4(),
      idCliente: '',
      nome: nome,
      parentesco: parentesco,
      dataNascimento: dataNascimento,
    );
    _tempDependentes.add(newDependent);
    notifyListeners();
  }

  void removeTempDependent(String idDependente) {
    _tempDependentes.removeWhere((d) => d.idDependente == idDependente);
    notifyListeners();
  }

  Future<void> loadClients() async {
    _setLoading(true);

    await _clientService.initialize();

    await Future.delayed(const Duration(milliseconds: 50));
    _clients = _clientService.getAllClients();
    _setLoading(false);
  }

  Future<void> searchCep(String cep) async {
    final cleanedCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedCep.length != 8) return;

    _clearAddressFields();
    _logradouro = 'Buscando...';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cleanedCep/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          _clearAddressFields();
          _logradouro = 'CEP não encontrado.';
        } else {
          _logradouro = data['logradouro'] ?? '';
          _bairro = data['bairro'] ?? '';
          _cidade = data['localidade'] ?? '';
          _estado = data['uf'] ?? '';
        }
      } else {
        _logradouro = 'Erro na requisição: ${response.statusCode}';
      }
    } catch (e) {
      _logradouro = 'Erro de conexão.';
      if (kDebugMode) print('Erro na girimboca da parafuseta');
    }

    notifyListeners();
  }

  Future<void> searchCnpj(String cnpj) async {
    final cleanedCnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedCnpj.length < 14) return;

    _clearCnpjFields();
        _empresa = 'Buscando...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (cleanedCnpj.startsWith('00')) {
      _empresa = 'Diretor Executivo';
    } else if (cleanedCnpj.startsWith('10')) {
      _empresa = 'Analista Júnior';
    } else {
      _empresa = 'Não sugerido';
    }

    notifyListeners();
  }

  Future<void> addNewClient({
    required String nome,
    required String cpf,
    required DateTime dataNascimento,
    required String telefone,
    required String email,
    required String cep,
    required String logradouro,
    required String numero,
    required String bairro,
    required String cidade,
    required String estado,
    String? complemento,
    String? empresaCnpj,
    String? cargo,
  }) async {
    final clientId = uuid.v4();

    final dependentsToSave = _tempDependentes.map((d) {
      d.idCliente = clientId;
      return d;
    }).toList();

    final newClient = ClientModel(
      idCliente: clientId,
      nome: nome,
      cpf: cpf,
      dataNascimento: dataNascimento,
      telefone: telefone,
      email: email,
      cep: cep,
      logradouro: logradouro,
      numero: numero,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
      complemento: complemento,
      empresaCnpj: empresaCnpj,
      cargo: cargo,
      dependentes: dependentsToSave,
      dataCadastro: DateTime.now(),
    );

    await _clientService.addClient(newClient);
    clearTempDependents();
    await loadClients();
  }

  Future<void> updateClient(ClientModel client) async {
    await _clientService.updateClient(client);
    notifyListeners();
  }

  Future<void> deleteClient(ClientModel client) async {
    await _clientService.deleteClient(client);

    _clients.removeWhere((c) => c.key == client.key);

    notifyListeners();
  }
}
