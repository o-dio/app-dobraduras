import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dobradura_provider.dart';
import '../widgets/admin_banner.dart';
import '../widgets/app_header.dart';
import '../widgets/dobradura_carrossel.dart';

/// Tela inicial do aplicativo de dobraduras.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DobraduraProvider>();
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppHeader(titulo: 'Início'),
      body: Column(
        children: [
          const AdminBanner(),
          Expanded(
            child: Builder(
              builder: (context) {
                if (provider.carregando) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.erro != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_off_outlined,
                            size: 56,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.erro!,
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => provider.carregarDobraduras(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.todas.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            size: 56,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhuma dobradura cadastrada ainda.',
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          if (isAdmin) ...[
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/admin/dobradura',
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Adicionar dobradura'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                final historico = provider.historico;
                final galeriaPorTipo = provider.agrupadasPorTipo;

                return RefreshIndicator(
                  onRefresh: () => provider.carregarDobraduras(silencioso: true),
                  child: ListView(
                    // Garante que o gesto de puxar funcione mesmo com poucos itens na tela
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      DobraduraCarrossel(
                        titulo: 'Histórico',
                        dobraduras: historico,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Galeria',
                              style: textTheme.titleLarge,
                            ),
                            if (isAdmin)
                              IconButton.filledTonal(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/admin/dobradura',
                                ),
                                icon: const Icon(Icons.add),
                                tooltip: 'Adicionar dobradura',
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
