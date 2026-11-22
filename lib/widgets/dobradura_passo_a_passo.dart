import 'package:flutter/material.dart';
import '../models/dobradura.dart';
import 'dobradura_video_player.dart';

/// Seção de passo-a-passo: exibe carrossel de imagens, player de vídeo ou ambos (vídeo no final).
class DobraduraPassoAPasso extends StatefulWidget {
  const DobraduraPassoAPasso({
    super.key,
    required this.dobradura,
  });

  final Dobradura dobradura;

  @override
  State<DobraduraPassoAPasso> createState() => _DobraduraPassoAPassoState();
}

class _DobraduraPassoAPassoState extends State<DobraduraPassoAPasso> {
  late final PageController _pageController;
  int _paginaAtual = 0;

  int get _totalSlides =>
      widget.dobradura.imagensPasso.length + (widget.dobradura.temVideo ? 1 : 0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _irParaPagina(int indice) {
    _pageController.animateToPage(
      indice,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSlideImagem(BuildContext context, String url, int numeroPasso) {
    final colorScheme = Theme.of(context).colorScheme;

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Imagem do passo $numeroPasso',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideVideo(BuildContext context) {
    return DobraduraVideoPlayer(videoUrl: widget.dobradura.videoPassoUrl!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final imagens = widget.dobradura.imagensPasso;

    if (_totalSlides == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Passo-a-passo ainda não disponível.',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalSlides,
              onPageChanged: (indice) => setState(() => _paginaAtual = indice),
              itemBuilder: (context, indice) {
                final ehSlideVideo = widget.dobradura.temVideo && indice == imagens.length;
                if (ehSlideVideo) {
                  return _buildSlideVideo(context);
                }
                return _buildSlideImagem(context, imagens[indice], indice + 1);
              },
            ),
          ),
          if (_totalSlides > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Anterior',
                    onPressed: _paginaAtual > 0 ? () => _irParaPagina(_paginaAtual - 1) : null,
                  ),
                  Text('${_paginaAtual + 1} / $_totalSlides', style: textTheme.bodyMedium),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Próximo',
                    onPressed: _paginaAtual < _totalSlides - 1
                        ? () => _irParaPagina(_paginaAtual + 1)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
