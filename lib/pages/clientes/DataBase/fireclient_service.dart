import 'package:cadrey/pages/clientes/DataBase/fireclient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_dart/firebase_auth_dart.dart';

class FireClientService {

  String idCliente;
  FireClientService() : idCliente = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> AdicionarCliente(FireClientModel fireClientModel) async {
    await _firestore
    .collection(idCliente)
    .doc(fireClientModel.idCliente)
    .set(fireClientModel.toMap());
  }
}