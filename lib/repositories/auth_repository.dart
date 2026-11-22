/// Repositório responsável pela autenticação do administrador.
///
/// Atualmente usa credenciais mockadas em memória. No futuro, esta classe
/// será conectada ao Firebase Auth sem necessidade de alterar as telas.
class AuthRepository {
  static const String _emailAdmin = 'admin@dobraduras.com';
  static const String _senhaAdmin = 'admin123';

  /// Valida as credenciais informadas.
  ///
  /// Retorna `true` se o login for válido e `false` caso contrário.
  /// Assinatura assíncrona (`Future`) já preparada para integração com Firebase.
  Future<bool> autenticar({
    required String email,
    required String senha,
  }) async {
    // Simula uma pequena latência de rede (como ocorrerá no Firebase Auth)
    await Future.delayed(const Duration(milliseconds: 400));

    return email.trim().toLowerCase() == _emailAdmin && senha == _senhaAdmin;
  }
}
