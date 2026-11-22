import '../models/dobradura.dart';

/// Repositório de dobraduras (atualmente com dados mockados para desenvolvimento).
class DobraduraRepository {
  /// Catálogo mockado de todas as dobraduras disponíveis.
  List<Dobradura> listarTodas() {
    return const [
      // Cenário 1: imagens + vídeo no final do carrossel
      Dobradura(
        id: 'tsuru',
        nome: 'Tsuru',
        tipo: 'Animais',
        dificuldade: 'Intermediário',
        imagensPasso: ['mock://tsuru/passo-1', 'mock://tsuru/passo-2', 'mock://tsuru/passo-3'],
        videoPassoUrl: 'mock://tsuru/video',
      ),
      // Cenário 2: somente imagens
      Dobradura(
        id: 'sapo',
        nome: 'Sapo Saltador',
        tipo: 'Animais',
        dificuldade: 'Fácil',
        imagensPasso: ['mock://sapo/passo-1', 'mock://sapo/passo-2'],
      ),
      // Cenário 3: somente vídeo (vídeo oficial de teste do Flutter)
      Dobradura(
        id: 'raposa',
        nome: 'Raposa',
        tipo: 'Animais',
        dificuldade: 'Fácil',
        videoPassoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
      // Cenário 4: sem passo-a-passo cadastrado
      Dobradura(
        id: 'barquinho',
        nome: 'Barquinho de Papel',
        tipo: 'Veículos',
        dificuldade: 'Fácil',
      ),
      Dobradura(
        id: 'aviao',
        nome: 'Avião Clássico',
        tipo: 'Veículos',
        dificuldade: 'Fácil',
        imagensPasso: ['mock://aviao/passo-1'],
      ),
      Dobradura(id: 'flor-lotus', nome: 'Flor de Lótus', tipo: 'Flores', dificuldade: 'Difícil'),
      Dobradura(id: 'tulipa', nome: 'Tulipa', tipo: 'Flores', dificuldade: 'Fácil'),
    ];
  }

  /// Retorna as dobraduras acessadas recentemente pelo usuário.
  List<Dobradura> listarHistorico() {
    return listarTodas().take(4).toList();
  }

  /// Agrupa dinamicamente todas as dobraduras pelo seu [tipo].
  Map<String, List<Dobradura>> listarAgrupadasPorTipo() {
    final mapa = <String, List<Dobradura>>{};
    for (final dobradura in listarTodas()) {
      mapa.putIfAbsent(dobradura.tipo, () => []).add(dobradura);
    }
    return mapa;
  }

  /// Busca uma dobradura específica pelo seu [id]. Retorna `null` se não existir.
  Dobradura? buscarPorId(String id) {
    for (final dobradura in listarTodas()) {
      if (dobradura.id == id) {
        return dobradura;
      }
    }
    return null;
  }
}
