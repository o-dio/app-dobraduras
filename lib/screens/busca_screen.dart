import 'package:flutter/material.dart';
import '../models/dobradura.dart';
import '../repositories/dobradura_repository.dart';
import '../widgets/app_header.dart';
import '../widgets/dobradura_info_card.dart';

/// Tela dedicada de busca e filtragem de dobraduras.
class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final _repository = DobraduraRepository();
  final _termoController = TextEditingController();

  late final List<String> _tiposDisponiveis;

  final Set<String> _tiposSelecionados = {};
  final Set<DificuldadeDobradura> _dificuldadesSelecionadas = {};
  final Set<EstruturaDobradura> _estruturasSelecionadas = {};
  final Set<TipoInstrucao> _instrucoesSelecionadas = {};

  @override
  void initState() {
    super.initState();
    _tiposDisponiveis = _repository.listarTipos();
  }

  @override
  void dispose() {
    _termoController.dispose();
    super.dispose();
  }

  int get _totalFiltrosAtivos =>
      _tiposSelecionados.length +
      _dificuldadesSelecionadas.length +
      _estruturasSelecionadas.length +
      _instrucoesSelecionadas.length;

  bool get _temAlgumFiltroOuTermo =>
      _termoController.text.trim().isNotEmpty || _totalFiltrosAtivos > 0;

  void _limparFiltros() {
    setState(() {
      _tiposSelecionados.clear();
      _dificuldadesSelecionadas.clear();
      _estruturasSelecionadas.clear();
      _instrucoesSelecionadas.clear();
    });
  }

  void _limparTudo() {
    setState(() {
      _termoController.clear();
      _tiposSelecionados.clear();
      _dificuldadesSelecionadas.clear();
      _estruturasSelecionadas.clear();
      _instrucoesSelecionadas.clear();
    });
  }

  void _alternarSelecao<T>(Set<T> conjunto, T valor) {
    setState(() {
      if (!conjunto.remove(valor)) {
        conjunto.add(valor);
      }
    });
  }

  void _abrirDobradura(Dobradura dobradura) {
    Navigator.pushNamed(
      context,
      '/dobradura',
      arguments: dobradura.id,
    );
  }

  Widget _construirGrupoChips<T>({
    required String titulo,
    required List<T> opcoes,
    required Set<T> selecionados,
    required String Function(T) obterLabel,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final opcao in opcoes)
                FilterChip(
                  label: Text(obterLabel(opcao)),
                  selected: selecionados.contains(opcao),
                  onSelected: (_) => _alternarSelecao(selecionados, opcao),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _repository.buscar(
      termo: _termoController.text,
      tipos: _tiposSelecionados,
      dificuldades: _dificuldadesSelecionadas,
      estruturas: _estruturasSelecionadas,
      instrucoes: _instrucoesSelecionadas,
    );

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(titulo: 'Buscar'),
      body: Column(
        children: [
          // Campo de busca textual
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _termoController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou categoria...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _termoController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Limpar texto',
                        onPressed: () {
                          _termoController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // Painel expansível de filtros
          ExpansionTile(
            title: Text(
              _totalFiltrosAtivos > 0
                  ? 'Filtros ($_totalFiltrosAtivos ativos)'
                  : 'Filtros',
            ),
            leading: const Icon(Icons.filter_list),
            trailing: _totalFiltrosAtivos > 0
                ? TextButton(
                    onPressed: _limparFiltros,
                    child: const Text('Limpar'),
                  )
                : null,
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _construirGrupoChips<String>(
                titulo: 'Tipo',
                opcoes: _tiposDisponiveis,
                selecionados: _tiposSelecionados,
                obterLabel: (tipo) => tipo,
              ),
              _construirGrupoChips<DificuldadeDobradura>(
                titulo: 'Dificuldade',
                opcoes: DificuldadeDobradura.values,
                selecionados: _dificuldadesSelecionadas,
                obterLabel: (d) => d.label,
              ),
              _construirGrupoChips<EstruturaDobradura>(
                titulo: 'Estrutura',
                opcoes: EstruturaDobradura.values,
                selecionados: _estruturasSelecionadas,
                obterLabel: (e) => e.label,
              ),
              _construirGrupoChips<TipoInstrucao>(
                titulo: 'Instruções disponíveis',
                opcoes: TipoInstrucao.values,
                selecionados: _instrucoesSelecionadas,
                obterLabel: (i) => i.label,
              ),
            ],
          ),

          // Contador de resultados
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                resultados.length == 1
                    ? '1 dobradura encontrada'
                    : '${resultados.length} dobraduras encontradas',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Lista de resultados ou estado vazio
          Expanded(
            child: resultados.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_outlined,
                            size: 56,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nenhuma dobradura encontrada',
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          if (_temAlgumFiltroOuTermo) ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _limparTudo,
                              icon: const Icon(Icons.filter_alt_off_outlined),
                              label: const Text('Limpar busca e filtros'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: resultados.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final dobradura = resultados[index];
                      return DobraduraInfoCard(
                        dobradura: dobradura,
                        onTap: () => _abrirDobradura(dobradura),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
