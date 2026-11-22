import 'package:flutter/material.dart';

/// Cabeçalho compartilhado por todas as páginas internas do aplicativo.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.titulo,
    this.onSearchPressed,
  });

  /// Texto exibido no centro indicando a tela atual.
  final String titulo;

  /// Ação disparada ao clicar na lupa de pesquisa.
  final VoidCallback? onSearchPressed;

  void _irParaHome(BuildContext context) {
    final rotaAtual = ModalRoute.of(context)?.settings.name;
    if (rotaAtual != '/home') {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 1. Logo do app (placeholder até definirmos a identidade visual)
      leading: IconButton(
        icon: const Icon(Icons.auto_awesome),
        tooltip: 'Ir para o início',
        onPressed: () => _irParaHome(context),
      ),
      // 2. Título da tela atual (ocupa o espaço central disponível)
      title: Text(
        titulo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // 3. Ação de pesquisa (abrirá o menu de pesquisa)
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Pesquisar',
          onPressed: onSearchPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
