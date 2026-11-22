import 'package:flutter/material.dart';
import '../models/dobradura.dart';
import 'dobradura_card.dart';

/// Seção com título e carrossel horizontal de dobraduras.
/// Fica oculta automaticamente quando a lista está vazia.
class DobraduraCarrossel extends StatelessWidget {
  const DobraduraCarrossel({
    super.key,
    required this.titulo,
    required this.dobraduras,
    this.altura = 180,
    this.estiloTitulo,
  });

  final String titulo;
  final List<Dobradura> dobraduras;
  final double altura;
  final TextStyle? estiloTitulo;

  @override
  Widget build(BuildContext context) {
    if (dobraduras.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            titulo,
            style: estiloTitulo ?? Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: altura,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: dobraduras.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return DobraduraCard(dobradura: dobraduras[index]);
            },
          ),
        ),
      ],
    );
  }
}
