import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

/// Gerencia o estado global de autenticação do administrador.
///
/// Usa `ChangeNotifier` para notificar automaticamente qualquer widget
/// que esteja observando `isAdmin` quando houver login ou logout.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  bool _isAdmin = false;
  bool _carregando = false;

  /// Indica se o usuário atual está autenticado como administrador.
  bool get isAdmin => _isAdmin;

  /// Indica se há uma tentativa de login em andamento.
  bool get carregando => _carregando;

  /// Tenta autenticar o administrador e atualiza o estado global.
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    _carregando = true;
    notifyListeners();

    final sucesso = await _repository.autenticar(email: email, senha: senha);

    _isAdmin = sucesso;
    _carregando = false;
    notifyListeners();

    return sucesso;
  }

  /// Encerra a sessão do administrador e retorna ao modo usuário comum.
  void logout() {
    if (!_isAdmin) return;
    _isAdmin = false;
    notifyListeners();
  }
}
