import 'package:flutter/material.dart';
import '../repositories/dobradura_repository.dart';
import '../widgets/app_header.dart';
import '../widgets/dobradura_carrossel.dart';

/// Tela inicial do aplicativo de dobraduras.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _repository = DobraduraRepository();

  @override
  Widget build(BuildContext context) {
    final historico = _repository.listarHistorico();
    final galeriaPorTipo = _repository.listarAgrupadasPorTipo();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppHeader(
        titulo: 'Início',
        onSearchPressed: () {
          // TODO: abrir menu de pesquisa na próxima etapa
        },
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          DobraduraCarrossel(
            titulo: 'Histórico',
            dobraduras: historico,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Text(
              'Galeria',
              style: textTheme.titleLarge,
            ),
          ),
          for (final entry in galeriaPorTipo.entries)
            DobraduraCarrossel(
              titulo: entry.key,
              dobraduras: entry.value,
              estiloTitulo: textTheme.titleMedium,
            ),
        ],
      ),
    );
  }
}
