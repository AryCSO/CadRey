import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String collectionName = 'Cad. Clientes';

class ClientService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initialize() async {}

  Future<void> addClient(ClientModel client) async {
    await _db.collection(collectionName).add(client.toMap());
  }

  Future<List<ClientModel>> getAllClients() async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map((doc) {
      return ClientModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Stream<List<ClientModel>> getClientsStream() {
    return _db.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClientModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateClient(ClientModel client) async {
    if (client.id != null) {
      await _db.collection(collectionName).doc(client.id).update(client.toMap());
    }
  }

  Future<void> deleteClient(ClientModel client) async {
    if (client.id != null) {
      await _db.collection(collectionName).doc(client.id).delete();
    }
  }
}