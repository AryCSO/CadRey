import 'dart:convert';
import 'package:cadrey/pages/clientes/Model/client_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String collectionName = 'Cad. Clientes';

class ClientService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initialize() async {}

  
  Future<Map<String, dynamic>?> fetchCep(String cep) async {
    
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanCep.length != 8) return null;

    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data.containsKey('erro')) {
          return null;
        }
        return data;
      }
    } catch (e) {
      
      print('Erro ao buscar CEP: $e');
    }
    return null;
  }

  
  
  Future<Map<String, dynamic>?> fetchCnpj(String cnpj) async {
    final cleanCnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCnpj.length != 14) return null;

    try {
      final url = Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$cleanCnpj');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar CNPJ: $e');
    }
    return null;
  }

  

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