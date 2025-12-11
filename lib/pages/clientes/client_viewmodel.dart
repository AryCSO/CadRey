
import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cadrey/pages/clientes/client_service.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ClientViewModel extends ChangeNotifier {
  final ClientService _clientService;
  List<ClientModel> _clients = [];
  bool _isLoading = false;

  String _logradouro = '';
  String _bairro = '';
  String _cidade = '';
  String _estado = '';
  String _numero = ''; // Adicionado para mapear com o novo model
  String _empresa = '';
  String _nomeRazaoSocial = ''; // Adicionado

  List<DependentModel> _tempDependentes = [];

  List<ClientModel> get clients => _clients;
  bool get isLoading => _isLoading;
  String get logradouro => _logradouro;
  String get numero => _numero;
  String get bairro => _bairro;
  String get cidade => _cidade;
  String get estado => _estado;
  String get empresa => _empresa;
  String get nomeRazaoSocial => _nomeRazaoSocial;
  List<DependentModel> get tempDependentes => _tempDependentes;

  ClientViewModel(this._clientService);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ignore: unused_element
  void _clearAddressFields() {
    _logradouro = ''; _bairro = ''; _cidade = ''; _estado = ''; _numero = '';
    notifyListeners();
  }
  // ignore: unused_element
  void _clearCnpjFields() {
    _empresa = ''; _nomeRazaoSocial = '';
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
    
    try {
      _clients = await _clientService.getAllClients();
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao carregar clientes: $e");
      }
      _clients = [];
    }
    
    _setLoading(false);
  }

  Future<void> searchCep(String cep) async { /* Código existente */ }
  Future<void> searchCnpj(String cnpj) async { /* Código existente */ }

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
    await loadClients();
  }

  Future<void> deleteClient(ClientModel client) async {
    await _clientService.deleteClient(client);
    _clients.removeWhere((c) => c.id == client.id);
    notifyListeners();
  }
}