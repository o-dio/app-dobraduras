/// Representa uma dobradura no domínio do aplicativo.
class Dobradura {
  const Dobradura({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.dificuldade,
    this.imagemUrl,
    this.imagensPasso = const [],
    this.videoPassoUrl,
  });

  final String id;
  final String nome;
  final String tipo;
  final String dificuldade;
  final String? imagemUrl;
  final List<String> imagensPasso;
  final String? videoPassoUrl;

  bool get temVideo => videoPassoUrl != null && videoPassoUrl!.isNotEmpty;

  /// Constrói uma [Dobradura] a partir de um mapa (preparado para o Firestore).
  factory Dobradura.fromMap(Map<String, dynamic> map, {required String id}) {
    return Dobradura(
      id: id,
      nome: map['nome'] as String? ?? '',
      tipo: map['tipo'] as String? ?? 'Outros',
      dificuldade: map['dificuldade'] as String? ?? 'Não informada',
      imagemUrl: map['imagemUrl'] as String?,
      imagensPasso: (map['imagensPasso'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      videoPassoUrl: map['videoPassoUrl'] as String?,
    );
  }

  /// Converte a [Dobradura] em mapa para persistência.
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
      'dificuldade': dificuldade,
      'imagemUrl': imagemUrl,
      'imagensPasso': imagensPasso,
      'videoPassoUrl': videoPassoUrl,
    };
  }
}
