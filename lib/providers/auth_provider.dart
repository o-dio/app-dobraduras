import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

/// Gerencia o estado global de autenticação do administrador.
///
/// Usa `ChangeNotifier` para notificar automaticamente qualquer widget
/// que esteja observando `isAdmin` quando houver login ou logout.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository) : _isAdmin = _repository.estaAutenticado {
    // Mantém o estado sincronizado com a sessão real do Firebase Auth
    _assinaturaAuth = _repository.estadoAutenticacao.listen((autenticado) {
      if (_isAdmin != autenticado) {
        _isAdmin = autenticado;
        notifyListeners();
      }
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<bool> _assinaturaAuth;

  bool _isAdmin;
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
  Future<void> logout() async {
    if (!_isAdmin) return;
    await _repository.sair();
    _isAdmin = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _assinaturaAuth.cancel();
    super.dispose();
  }
}
