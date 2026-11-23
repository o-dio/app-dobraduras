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
        dificuldade: DificuldadeDobradura.intermediario,
        estrutura: EstruturaDobradura.simples,
        imagensPasso: ['mock://tsuru/passo-1', 'mock://tsuru/passo-2', 'mock://tsuru/passo-3'],
        videoPassoUrl: 'mock://tsuru/video',
        algoritmo: '''1. Comece com um papel quadrado.
2. Dobre ao meio nas duas diagonais e desdobre.
3. Forme a base quadrada juntando as pontas.
4. Dobre as abas laterais até o centro e puxe a base pássaro.
5. Modele a cabeça, a cauda e abra as asas.''',
      ),
      // Cenário 2: somente imagens
      Dobradura(
        id: 'sapo',
        nome: 'Sapo Saltador',
        tipo: 'Animais',
        dificuldade: DificuldadeDobradura.facil,
        estrutura: EstruturaDobradura.simples,
        imagensPasso: ['mock://sapo/passo-1', 'mock://sapo/passo-2'],
        algoritmo: '''1. Dobre o papel ao meio formando um retângulo.
2. Crie as dobras diagonais no topo para formar um triângulo.
3. Dobre as pernas traseiras em zigue-zague para dar impulso.''',
      ),
      // Cenário 3: somente vídeo (vídeo oficial de teste do Flutter)
      Dobradura(
        id: 'raposa',
        nome: 'Raposa',
        tipo: 'Animais',
        dificuldade: DificuldadeDobradura.facil,
        estrutura: EstruturaDobradura.simples,
        videoPassoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
      // Cenário 4: sem passo-a-passo cadastrado
      Dobradura(
        id: 'barquinho',
        nome: 'Barquinho de Papel',
        tipo: 'Veículos',
        dificuldade: DificuldadeDobradura.facil,
        estrutura: EstruturaDobradura.simples,
      ),
      Dobradura(
        id: 'aviao',
        nome: 'Avião Clássico',
        tipo: 'Veículos',
        dificuldade: DificuldadeDobradura.facil,
        estrutura: EstruturaDobradura.simples,
        imagensPasso: ['mock://aviao/passo-1'],
      ),
      Dobradura(
        id: 'flor-lotus',
        nome: 'Flor de Lótus',
        tipo: 'Flores',
        dificuldade: DificuldadeDobradura.dificil,
        estrutura: EstruturaDobradura.modular,
      ),
      Dobradura(
        id: 'tulipa',
        nome: 'Tulipa',
        tipo: 'Flores',
        dificuldade: DificuldadeDobradura.facil,
        estrutura: EstruturaDobradura.simples,
      ),
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

  /// Retorna os tipos únicos de dobraduras ordenados alfabeticamente (para filtros).
  List<String> listarTipos() {
    final tipos = listarTodas().map((d) => d.tipo).toSet().toList();
    tipos.sort();
    return tipos;
  }

  /// Filtra dobraduras por [termo] e filtros combináveis.
  ///
  /// Dentro de cada grupo de filtro aplica-se lógica OU (ex.: Fácil OU Difícil).
  /// Entre grupos distintos (e o termo textual) aplica-se lógica E.
  List<Dobradura> buscar({
    String termo = '',
    Set<String> tipos = const {},
    Set<DificuldadeDobradura> dificuldades = const {},
    Set<EstruturaDobradura> estruturas = const {},
    Set<TipoInstrucao> instrucoes = const {},
  }) {
    final termoNormalizado = termo.trim().toLowerCase();

    return listarTodas().where((dobradura) {
      if (termoNormalizado.isNotEmpty) {
        final bateNome = dobradura.nome.toLowerCase().contains(termoNormalizado);
        final bateTipo = dobradura.tipo.toLowerCase().contains(termoNormalizado);
        if (!bateNome && !bateTipo) return false;
      }

      if (tipos.isNotEmpty && !tipos.contains(dobradura.tipo)) {
        return false;
      }

      if (dificuldades.isNotEmpty && !dificuldades.contains(dobradura.dificuldade)) {
        return false;
      }

      if (estruturas.isNotEmpty && !estruturas.contains(dobradura.estrutura)) {
        return false;
      }

      if (instrucoes.isNotEmpty &&
          !instrucoes.any((i) => dobradura.instrucoesDisponiveis.contains(i))) {
        return false;
      }

      return true;
    }).toList();
  }
}
