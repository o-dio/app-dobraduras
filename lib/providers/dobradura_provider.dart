import 'package:flutter/foundation.dart';
import '../models/dobradura.dart';
import '../repositories/dobradura_repository.dart';

/// Gerencia o catálogo de dobraduras em memória e o histórico da sessão atual.
///
/// Faz a leitura no Cloud Firestore na abertura do app e sempre que
/// [carregarDobraduras] for chamado (ex.: ao clicar no logo do menu ou
/// após alterações feitas pelo administrador).
class DobraduraProvider extends ChangeNotifier {
  DobraduraProvider(this._repository) {
    carregarDobraduras();
  }

  final DobraduraRepository _repository;

  static const int _limiteHistorico = 10;

  List<Dobradura> _dobraduras = const [];
  final List<String> _historicoIds = [];
  bool _carregando = true;
  String? _erro;

  /// Todas as dobraduras carregadas em memória.
  List<Dobradura> get todas => _dobraduras;

  /// Indica se há um carregamento em andamento no Firestore.
  bool get carregando => _carregando;

  /// Mensagem de erro caso a última leitura no Firestore tenha falhado.
  String? get erro => _erro;

  /// Dobraduras acessadas nesta sessão (mais recentes primeiro).
  List<Dobradura> get historico {
    final lista = <Dobradura>[];
    for (final id in _historicoIds) {
      final dobradura = buscarPorId(id);
      if (dobradura != null) {
        lista.add(dobradura);
      }
    }
    return lista;
  }

  /// Agrupa dinamicamente todas as dobraduras em memória pelo seu `tipo`.
  Map<String, List<Dobradura>> get agrupadasPorTipo {
    final mapa = <String, List<Dobradura>>{};
    for (final dobradura in _dobraduras) {
      mapa.putIfAbsent(dobradura.tipo, () => []).add(dobradura);
    }
    return mapa;
  }

  /// Tipos únicos de dobraduras ordenados alfabeticamente (para filtros de busca).
  List<String> get tiposDisponiveis {
    final tipos = _dobraduras.map((d) => d.tipo).toSet().toList();
    tipos.sort();
    return tipos;
  }

  /// Busca o catálogo atualizado no Firestore e armazena em memória.
  Future<void> carregarDobraduras() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _dobraduras = await _repository.listarTodas();
    } catch (e) {
      _erro = 'Não foi possível carregar as dobraduras.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Busca uma dobradura específica em memória pelo [id].
  Dobradura? buscarPorId(String id) {
    for (final dobradura in _dobraduras) {
      if (dobradura.id == id) {
        return dobradura;
      }
    }
    return null;
  }

  /// Registra a visualização de uma dobradura no histórico da sessão atual.
  void registrarAcesso(String id) {
    _historicoIds.remove(id);
    _historicoIds.insert(0, id);
    if (_historicoIds.length > _limiteHistorico) {
      _historicoIds.removeLast();
    }
    notifyListeners();
  }

  /// Filtra as dobraduras em memória por [termo] e filtros combináveis.
  ///
  /// Lógica OU dentro de cada categoria e lógica E entre categorias distintas.
  List<Dobradura> buscar({
    String termo = '',
    Set<String> tipos = const {},
    Set<DificuldadeDobradura> dificuldades = const {},
    Set<EstruturaDobradura> estruturas = const {},
    Set<TipoInstrucao> instrucoes = const {},
  }) {
    final termoNormalizado = termo.trim().toLowerCase();

    return _dobraduras.where((dobradura) {
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
