import 'package:flutter/material.dart';
import '../models/dobradura.dart';

/// Card horizontal com informações gerais da dobradura (capa, nome, dificuldade, estrutura e ação opcional).
class DobraduraInfoCard extends StatelessWidget {
  const DobraduraInfoCard({
    super.key,
    required this.dobradura,
    this.onAlgoritmoPressed,
    this.onTap,
  });

  final Dobradura dobradura;
  final VoidCallback? onAlgoritmoPressed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagem de destaque à esquerda
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: dobradura.imagemUrl != null
                      ? Image.network(dobradura.imagemUrl!, fit: BoxFit.cover)
                      : Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_outlined,
                            size: 36,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Nome em destaque + nível de dificuldade + estrutura
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dobradura.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dobradura.dificuldade.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Estrutura: ${dobradura.estrutura.label}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Ação à direita: botão de algoritmo (na DobraduraScreen) ou seta (na lista de busca)
              if (onAlgoritmoPressed != null)
                IconButton(
                  icon: const Icon(Icons.account_tree_outlined),
                  tooltip: 'Ver algoritmo',
                  onPressed: onAlgoritmoPressed,
                )
              else if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
