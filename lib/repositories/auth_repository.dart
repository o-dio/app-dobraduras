import 'package:firebase_auth/firebase_auth.dart';

/// Repositório responsável pela autenticação do administrador.
///
/// Conectado ao Firebase Auth (método E-mail/Senha).
class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Indica se já existe um administrador autenticado na sessão atual.
  bool get estaAutenticado => _firebaseAuth.currentUser != null;

  /// Stream que emite `true` quando há usuário autenticado e `false` ao sair.
  Stream<bool> get estadoAutenticacao =>
      _firebaseAuth.authStateChanges().map((user) => user != null);

  /// Valida as credenciais informadas no Firebase Auth.
  ///
  /// Retorna `true` se o login for válido e `false` caso contrário.
  Future<bool> autenticar({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  /// Encerra a sessão do administrador no Firebase Auth.
  Future<void> sair() async {
    await _firebaseAuth.signOut();
  }
}
