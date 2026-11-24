import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dobradura.dart';
import '../providers/auth_provider.dart';
import '../providers/dobradura_provider.dart';
import '../widgets/admin_banner.dart';
import '../widgets/app_header.dart';

/// Formulário reutilizável do administrador para criar ou editar uma dobradura.
class DobraduraFormScreen extends StatefulWidget {
  const DobraduraFormScreen({super.key});

  @override
  State<DobraduraFormScreen> createState() => _DobraduraFormScreenState();
}

class _DobraduraFormScreenState extends State<DobraduraFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _tipoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _videoPassoUrlController = TextEditingController();
  final _algoritmoController = TextEditingController();
  final _modelo3dUrlController = TextEditingController();
  final List<TextEditingController> _imagensPassoControllers = [];

  DificuldadeDobradura _dificuldade = DificuldadeDobradura.facil;
  EstruturaDobradura _estrutura = EstruturaDobradura.simples;

  Dobradura? _dobraduraOriginal;
  bool _inicializado = false;
  bool _salvando = false;

  bool get _editando => _dobraduraOriginal != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicializado) return;
    _inicializado = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Dobradura) {
      _dobraduraOriginal = args;
      _nomeController.text = args.nome;
      _tipoController.text = args.tipo;
      _dificuldade = args.dificuldade;
      _estrutura = args.estrutura;
      _imagemUrlController.text = args.imagemUrl ?? '';
      _videoPassoUrlController.text = args.videoPassoUrl ?? '';
      _algoritmoController.text = args.algoritmo ?? '';
      _modelo3dUrlController.text = args.modelo3dUrl ?? '';
      for (final url in args.imagensPasso) {
        _imagensPassoControllers.add(TextEditingController(text: url));
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoController.dispose();
    _imagemUrlController.dispose();
    _videoPassoUrlController.dispose();
    _algoritmoController.dispose();
    _modelo3dUrlController.dispose();
    for (final controller in _imagensPassoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adicionarCampoImagemPasso() {
    setState(() {
      _imagensPassoControllers.add(TextEditingController());
    });
  }

  void _removerCampoImagemPasso(int index) {
    setState(() {
      final controller = _imagensPassoControllers.removeAt(index);
      controller.dispose();
    });
  }

  String? _textoOpcional(TextEditingController controller) {
    final texto = controller.text.trim();
    return texto.isEmpty ? null : texto;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final imagensPasso = _imagensPassoControllers
        .map((c) => c.text.trim())
        .where((url) => url.isNotEmpty)
        .toList();

    final dobradura = Dobradura(
      id: _dobraduraOriginal?.id ?? '',
      nome: _nomeController.text.trim(),
      tipo: _tipoController.text.trim(),
      dificuldade: _dificuldade,
      estrutura: _estrutura,
      imagemUrl: _textoOpcional(_imagemUrlController),
      imagensPasso: imagensPasso,
      videoPassoUrl: _textoOpcional(_videoPassoUrlController),
      algoritmo: _textoOpcional(_algoritmoController),
      modelo3dUrl: _textoOpcional(_modelo3dUrlController),
    );

    try {
      final provider = context.read<DobraduraProvider>();
      if (_editando) {
        await provider.atualizarDobradura(dobradura);
      } else {
        await provider.adicionarDobradura(dobradura);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Dobradura atualizada com sucesso.'
                : 'Dobradura cadastrada com sucesso.',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a dobradura. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final tiposExistentes = context.watch<DobraduraProvider>().tiposDisponiveis;
    final titulo = _editando ? 'Editar dobradura' : 'Nova dobradura';

    if (!isAdmin) {
      return Scaffold(
        appBar: AppHeader(titulo: titulo),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Acesso restrito ao administrador.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  ),
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
      appBar: AppHeader(titulo: titulo),
      body: Column(
        children: [
          const AdminBanner(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Informações obrigatórias',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome da dobradura.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tipoController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo / Categoria *',
                      hintText: 'Ex.: Animais, Flores, Geométricas',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o tipo da dobradura.';
                      }
                      return null;
                    },
                  ),
                  if (tiposExistentes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final tipo in tiposExistentes)
                          ActionChip(
                            label: Text(tipo),
                            onPressed: () {
                              _tipoController.text = tipo;
                            },
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DificuldadeDobradura>(
                    initialValue: _dificuldade,
                    decoration: const InputDecoration(
                      labelText: 'Dificuldade *',
                      border: OutlineInputBorder(),
                    ),
                    items: DificuldadeDobradura.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _dificuldade = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<EstruturaDobradura>(
                    initialValue: _estrutura,
                    decoration: const InputDecoration(
                      labelText: 'Estrutura *',
                      border: OutlineInputBorder(),
                    ),
                    items: EstruturaDobradura.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _estrutura = value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mídias e instruções (opcionais)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _imagemUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL da imagem de capa',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Imagens do passo-a-passo',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _adicionarCampoImagemPasso,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Adicionar imagem'),
                      ),
                    ],
                  ),
                  for (var i = 0; i < _imagensPassoControllers.length; i++) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _imagensPassoControllers[i],
                            decoration: InputDecoration(
                              labelText: 'URL da imagem ${i + 1}',
                              hintText: 'https://...',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.url,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _removerCampoImagemPasso(i),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Remover imagem',
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _videoPassoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL do vídeo do passo-a-passo',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _algoritmoController,
                    decoration: const InputDecoration(
                      labelText: 'Algoritmo / instruções em texto',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modelo3dUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL do modelo 3D',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _editando ? 'Salvar alterações' : 'Cadastrar dobradura',
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
