import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dobradura.dart';
import '../providers/auth_provider.dart';
import '../providers/dobradura_provider.dart';
import '../widgets/admin_banner.dart';
import '../widgets/algoritmo_dialog.dart';
import '../widgets/app_header.dart';
import '../widgets/dobradura_info_card.dart';
import '../widgets/dobradura_passo_a_passo.dart';

/// Tela de detalhes de uma dobradura (informações gerais, passo-a-passo e modelo 3D).
class DobraduraScreen extends StatefulWidget {
  const DobraduraScreen({super.key});

  @override
  State<DobraduraScreen> createState() => _DobraduraScreenState();
}

class _DobraduraScreenState extends State<DobraduraScreen> {
  String? _idRegistradoNoHistorico;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is String ? args : null;

    if (id != null && id != _idRegistradoNoHistorico) {
      _idRegistradoNoHistorico = id;
      // Registra no histórico após o frame atual para não disparar notifyListeners durante o build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final provider = context.read<DobraduraProvider>();
        if (provider.buscarPorId(id) != null) {
          provider.registrarAcesso(id);
        }
      });
    }
  }

  void _voltarParaMenu(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _abrirPopupAlgoritmo(BuildContext context, Dobradura dobradura) {
    showDialog<void>(
      context: context,
      builder: (context) => AlgoritmoDialog(dobradura: dobradura),
    );
  }

  Future<void> _confirmarExclusao(
    BuildContext context,
    Dobradura dobradura,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir dobradura'),
        content: Text(
          'Tem certeza que deseja excluir "${dobradura.nome}"? Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await context.read<DobraduraProvider>().excluirDobradura(dobradura.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${dobradura.nome}" excluída com sucesso.')),
      );
      _voltarParaMenu(context);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a dobradura.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DobraduraProvider>();
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is String ? args : null;

    if (provider.carregando) {
      return const Scaffold(
        appBar: AppHeader(titulo: 'Dobradura'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final dobradura = id != null ? provider.buscarPorId(id) : null;

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
      body: Column(
        children: [
          const AdminBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (isAdmin) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/admin/dobradura',
                          arguments: dobradura,
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Editar'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onPressed: () => _confirmarExclusao(context, dobradura),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Excluir'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                // Seção 1: Informações gerais
                DobraduraInfoCard(
                  dobradura: dobradura,
                  onAlgoritmoPressed: () =>
                      _abrirPopupAlgoritmo(context, dobradura),
                ),
                const SizedBox(height: 24),
                // Seção 2: Passo-a-passo
                Text(
                  'Passo-a-passo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DobraduraPassoAPasso(dobradura: dobradura),
                const SizedBox(height: 24),
                // Seção 3: Modelo 3D (espaço delimitado)
                Text(
                  'Modelo 3D',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
