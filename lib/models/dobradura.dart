/// Nível de dificuldade de uma dobradura.
enum DificuldadeDobradura {
  facil('Fácil'),
  intermediario('Intermediário'),
  dificil('Difícil');

  const DificuldadeDobradura(this.label);
  final String label;

  static DificuldadeDobradura fromString(String? valor) {
    final normalizado = valor?.trim().toLowerCase();
    for (final item in values) {
      if (item.name.toLowerCase() == normalizado ||
          item.label.toLowerCase() == normalizado) {
        return item;
      }
    }
    return DificuldadeDobradura.facil;
  }
}

/// Classificação estrutural de uma dobradura.
enum EstruturaDobradura {
  simples('Simples'),
  modular('Modular');

  const EstruturaDobradura(this.label);
  final String label;

  static EstruturaDobradura fromString(String? valor) {
    final normalizado = valor?.trim().toLowerCase();
    for (final item in values) {
      if (item.name.toLowerCase() == normalizado ||
          item.label.toLowerCase() == normalizado) {
        return item;
      }
    }
    return EstruturaDobradura.simples;
  }
}

/// Tipos de instruções disponíveis para auxiliar na montagem (usado nos filtros de busca).
enum TipoInstrucao {
  algoritmo('Algoritmo'),
  imagens('Imagens'),
  video('Vídeo'),
  modelo3d('Modelo 3D');

  const TipoInstrucao(this.label);
  final String label;
}

/// Representa uma dobradura no domínio do aplicativo.
class Dobradura {
  const Dobradura({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.dificuldade,
    required this.estrutura,
    this.imagemUrl,
    this.imagensPasso = const [],
    this.videoPassoUrl,
    this.algoritmo,
    this.modelo3dUrl,
  });

  final String id;
  final String nome;
  final String tipo;
  final DificuldadeDobradura dificuldade;
  final EstruturaDobradura estrutura;
  final String? imagemUrl;
  final List<String> imagensPasso;
  final String? videoPassoUrl;
  final String? algoritmo;
  final String? modelo3dUrl;

  bool get temVideo => videoPassoUrl != null && videoPassoUrl!.isNotEmpty;
  bool get temAlgoritmo => algoritmo != null && algoritmo!.trim().isNotEmpty;
  bool get temModelo3d => modelo3dUrl != null && modelo3dUrl!.isNotEmpty;

  /// Lista derivada das instruções disponíveis (fonte única da verdade para filtros de busca).
  List<TipoInstrucao> get instrucoesDisponiveis => [
        if (temAlgoritmo) TipoInstrucao.algoritmo,
        if (imagensPasso.isNotEmpty) TipoInstrucao.imagens,
        if (temVideo) TipoInstrucao.video,
        if (temModelo3d) TipoInstrucao.modelo3d,
      ];

  /// Constrói uma [Dobradura] a partir de um mapa (preparado para o Firestore).
  factory Dobradura.fromMap(Map<String, dynamic> map, {required String id}) {
    return Dobradura(
      id: id,
      nome: map['nome'] as String? ?? '',
      tipo: map['tipo'] as String? ?? 'Outros',
      dificuldade: DificuldadeDobradura.fromString(map['dificuldade'] as String?),
      estrutura: EstruturaDobradura.fromString(map['estrutura'] as String?),
      imagemUrl: map['imagemUrl'] as String?,
      imagensPasso: (map['imagensPasso'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      videoPassoUrl: map['videoPassoUrl'] as String?,
      algoritmo: map['algoritmo'] as String?,
      modelo3dUrl: map['modelo3dUrl'] as String?,
    );
  }

  /// Converte a [Dobradura] em mapa para persistência.
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
      'dificuldade': dificuldade.name,
      'estrutura': estrutura.name,
      'imagemUrl': imagemUrl,
      'imagensPasso': imagensPasso,
      'videoPassoUrl': videoPassoUrl,
      'algoritmo': algoritmo,
      'modelo3dUrl': modelo3dUrl,
      'instrucoesDisponiveis': instrucoesDisponiveis.map((e) => e.name).toList(),
    };
  }
}
