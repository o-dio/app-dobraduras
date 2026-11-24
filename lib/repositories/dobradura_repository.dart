import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dobradura.dart';

/// Repositório de dobraduras conectado à coleção `dobraduras` no Cloud Firestore.
class DobraduraRepository {
  DobraduraRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('dobraduras');

  /// Busca todas as dobraduras cadastradas no Firestore ordenadas por nome.
  Future<List<Dobradura>> listarTodas() async {
    final snapshot = await _colecao.orderBy('nome').get();
    return snapshot.docs
        .map((doc) => Dobradura.fromMap(doc.data(), id: doc.id))
        .toList();
  }
}
