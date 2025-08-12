import 'package:flutter/material.dart';

/// Widget que proporciona un fondo degradado con colores personalizables
/// Se puede usar como contenedor para cualquier pantalla
class GradientBackground extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? colors;

  const GradientBackground({
    super.key,
    required this.child,
    this.padding,
    this.colors,
  });

  @override
  GradientBackgroundState createState() => GradientBackgroundState();
}

class GradientBackgroundState extends State<GradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores por defecto (morado) si no se proporcionan
    final defaultColors = [
      const Color(0xFF4A148C), // Morado muy oscuro
      const Color(0xFF6A1B9A), // Morado oscuro
      const Color(0xFF8E24AA), // Morado medio
      const Color(0xFFAB47BC), // Morado claro
      const Color(0xFFBA68C8), // Morado muy claro
    ];
    
    final colors = widget.colors ?? defaultColors;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: colors.length > 1 
                ? List.generate(colors.length, (index) => index / (colors.length - 1))
                : const [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Efectos de partículas animadas
              Positioned.fill(
                child: CustomPaint(
                  painter: ParticlePainter(_animation.value),
                ),
              ),
              // Contenido principal
              SafeArea(
                child: Padding(
                  padding: widget.padding ?? const EdgeInsets.all(20),
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pintor personalizado para efectos de partículas
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Dibujar partículas animadas
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1 + animationValue * 0.2)) % size.width;
      final y = (size.height * (i * 0.15 + animationValue * 0.1)) % size.height;
      final radius = 2.0 + (i % 3) * 1.0;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
