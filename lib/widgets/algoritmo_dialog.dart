import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/dobradura.dart';

/// Pop-up que exibe o algoritmo da dobradura em bloco selecionável com botão de copiar.
class AlgoritmoDialog extends StatefulWidget {
  const AlgoritmoDialog({
    super.key,
    required this.dobradura,
  });

  final Dobradura dobradura;

  @override
  State<AlgoritmoDialog> createState() => _AlgoritmoDialogState();
}

class _AlgoritmoDialogState extends State<AlgoritmoDialog> {
  bool _copiado = false;

  Future<void> _copiarAlgoritmo(String texto) async {
    await Clipboard.setData(ClipboardData(text: texto));
    if (!mounted) return;
    setState(() => _copiado = true);

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copiado = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final algoritmo = widget.dobradura.algoritmo?.trim();
    final temAlgoritmo = algoritmo != null && algoritmo.isNotEmpty;

    return AlertDialog(
      title: Text('Algoritmo — ${widget.dobradura.nome}'),
      content: SizedBox(
        width: double.maxFinite,
        child: temAlgoritmo
            ? Container(
                constraints: const BoxConstraints(maxHeight: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    algoritmo,
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                ),
              )
            : Text(
                'Algoritmo ainda não cadastrado para esta dobradura.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ),
      actions: [
        if (temAlgoritmo)
          TextButton.icon(
            onPressed: () => _copiarAlgoritmo(algoritmo),
            icon: Icon(_copiado ? Icons.check : Icons.copy),
            label: Text(_copiado ? 'Copiado!' : 'Copiar'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
