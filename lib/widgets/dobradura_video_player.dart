import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Reprodutor de vídeo para o passo-a-passo de uma dobradura.
class DobraduraVideoPlayer extends StatefulWidget {
  const DobraduraVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  State<DobraduraVideoPlayer> createState() => _DobraduraVideoPlayerState();
}

class _DobraduraVideoPlayerState extends State<DobraduraVideoPlayer> {
  VideoPlayerController? _controller;
  bool _carregando = true;
  bool _erroAoCarregar = false;
  bool _mostrarControles = true;
  Timer? _timerOcultar;

  @override
  void initState() {
    super.initState();
    _inicializarPlayer();
  }

  Future<void> _inicializarPlayer() async {
    try {
      final uri = Uri.parse(widget.videoUrl);
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        setState(() {
          _carregando = false;
          _erroAoCarregar = true;
        });
        return;
      }

      final controller = VideoPlayerController.networkUrl(uri);
      await controller.initialize();
      controller.setLooping(true);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erroAoCarregar = true;
      });
    }
  }

  @override
  void dispose() {
    _timerOcultar?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _agendarOcultarControles() {
    _timerOcultar?.cancel();
    _timerOcultar = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_controller?.value.isPlaying ?? false) {
        setState(() => _mostrarControles = false);
      }
    });
  }

  void _aoTocarNoVideo() {
    if (!(_controller?.value.isPlaying ?? false)) return;
    setState(() => _mostrarControles = !_mostrarControles);
    if (_mostrarControles) _agendarOcultarControles();
  }

  void _alternarReproducao() {
    final controller = _controller;
    if (controller == null) return;

    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        _timerOcultar?.cancel();
        _mostrarControles = true;
      } else {
        controller.play();
        _agendarOcultarControles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_carregando) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_erroAoCarregar || _controller == null) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_outlined, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              'Vídeo indisponível no momento',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    final controller = _controller!;
    final tocando = controller.value.isPlaying;

    return GestureDetector(
      onTap: _aoTocarNoVideo,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
          ),
          // Botão central de Play / Pause com fade automático
          IgnorePointer(
            ignoring: !_mostrarControles,
            child: AnimatedOpacity(
              opacity: _mostrarControles ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IconButton.filledTonal(
                iconSize: 40,
                icon: Icon(tocando ? Icons.pause : Icons.play_arrow),
                tooltip: tocando ? 'Pausar' : 'Reproduzir',
                onPressed: _alternarReproducao,
              ),
            ),
          ),
          // Barra de progresso interativa na base
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: true,
            ),
          ),
        ],
      ),
    );
  }
}
