import 'package:flutter/material.dart';
import '../models/dobradura.dart';

/// Card que exibe uma dobradura (imagem + nome) e abre sua página ao tocar.
class DobraduraCard extends StatelessWidget {
  const DobraduraCard({
    super.key,
    required this.dobradura,
    this.largura = 140,
  });

  final Dobradura dobradura;
  final double largura;

  void _abrirDobradura(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/dobradura',
      arguments: dobradura.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: largura,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _abrirDobradura(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Área da imagem
              Expanded(
                child: dobradura.imagemUrl != null
                    ? Image.network(
                        dobradura.imagemUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              // Nome da dobradura embaixo
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  dobradura.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
