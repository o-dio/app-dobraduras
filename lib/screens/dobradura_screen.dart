import 'package:flutter/material.dart';
import '../models/dobradura.dart';
import '../repositories/dobradura_repository.dart';
import '../widgets/algoritmo_dialog.dart';
import '../widgets/app_header.dart';
import '../widgets/dobradura_info_card.dart';
import '../widgets/dobradura_passo_a_passo.dart';

/// Tela de detalhes de uma dobradura (informações gerais, passo-a-passo e modelo 3D).
class DobraduraScreen extends StatelessWidget {
  DobraduraScreen({super.key});

  final _repository = DobraduraRepository();

  void _voltarParaMenu(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _abrirPopupAlgoritmo(BuildContext context, Dobradura dobradura) {
    showDialog<void>(
      context: context,
      builder: (context) => AlgoritmoDialog(dobradura: dobradura),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is String ? args : null;
    final dobradura = id != null ? _repository.buscarPorId(id) : null;

    if (dobradura == null) {
      return Scaffold(
        appBar: const AppHeader(titulo: 'Dobradura'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Dobradura não encontrada',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _voltarParaMenu(context),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Voltar ao início'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppHeader(titulo: dobradura.nome),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção 1: Informações gerais
          DobraduraInfoCard(
            dobradura: dobradura,
            onAlgoritmoPressed: () => _abrirPopupAlgoritmo(context, dobradura),
          ),
          const SizedBox(height: 24),
          // Seção 2: Passo-a-passo
          Text('Passo-a-passo', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          DobraduraPassoAPasso(dobradura: dobradura),
          const SizedBox(height: 24),
          // Seção 3: Modelo 3D (espaço delimitado)
          Text('Modelo 3D', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: SizedBox(
              height: 220,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.view_in_ar_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Visualização 3D em breve',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
