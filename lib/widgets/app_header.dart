import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

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

  bool _estaNaHome(BuildContext context) {
    return ModalRoute.of(context)?.settings.name == '/home';
  }

  void _aoClicarNoLogo(BuildContext context) {
    if (_estaNaHome(context)) {
      // Na /home, clique simples recarrega a página inicial
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Nas demais telas, volta para a /home limpando a pilha
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  Future<void> _aoDarDuploCliqueNoLogo(BuildContext context) async {
    if (!_estaNaHome(context)) return;

    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isAdmin) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    // Se já estiver logado como admin, confirma se deseja sair
    final confirmarSaida = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modo Administrador'),
        content: const Text('Deseja sair do modo administrador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmarSaida == true && context.mounted) {
      authProvider.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modo administrador desativado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      // 1. Logo do app: clique simples navega/recarrega; duplo clique na /home abre login ou logout
      leading: Tooltip(
        message: 'Ir para o início',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _aoClicarNoLogo(context),
          onDoubleTap: () => _aoDarDuploCliqueNoLogo(context),
          child: Icon(
            Icons.auto_awesome,
            // Destaque discreto na cor primária quando o modo admin está ativo
            color: isAdmin ? colorScheme.primary : null,
          ),
        ),
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
