import 'package:cadrey/models/client_model.dart';
import 'package:hive/hive.dart';

const String clientBoxName = 'clients';

class ClientService {
  late Box<ClientModel> _clientBox;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(clientBoxName)) {
      _clientBox = await Hive.openBox<ClientModel>(clientBoxName);
    } else {
      _clientBox = Hive.box<ClientModel>(clientBoxName);
    }
  }

  Future<void> addClient(ClientModel client) async {
    await _clientBox.add(client);
  }

  List<ClientModel> getAllClients() {
    return _clientBox.values.toList();
  }

  ClientModel? getClient(dynamic key) {
    return _clientBox.get(key);
  }

  Future<void> updateClient(ClientModel client) async {
    await client.save();
  }

  Future<void> deleteClient(ClientModel client) async {
    await client.delete();
  }
}