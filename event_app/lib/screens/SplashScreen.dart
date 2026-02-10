// File: lib/screens/SplashScreen.dart
// A polished, reusable splash screen widget with animation and optional navigation.
//
// Usage examples:
//   // Navigate to a named route after splash:
//   SplashScreen(nextRoute: '/home')
//
//   // Provide an asset logo and a callback instead of navigation:
//   SplashScreen(
//     logoAsset: 'assets/logo.png',
//     duration: const Duration(seconds: 4),
//     onInitializationComplete: () { /* do custom work */ },
//   )

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  // How long the splash shows before navigating / calling callback.
  final Duration duration;

  // Named route to navigate to after the splash (if provided).
  final String? nextRoute;

  // Alternative to nextRoute: a callback invoked when splash finishes.
  final VoidCallback? onInitializationComplete;

  // Optional asset image for the logo. If null, FlutterLogo is used.
  final String? logoAsset;

  // App title and subtitle shown on the splash screen.
  final String title;
  final String? subtitle;

  // Background gradient; default is a subtle professional gradient.
  final Gradient? backgroundGradient;

  const SplashScreen({
    Key? key,
    this.duration = const Duration(milliseconds: 3500),
    this.nextRoute,
    this.onInitializationComplete,
    this.logoAsset,
    this.title = 'My App',
    this.subtitle,
    this.backgroundGradient,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late Timer _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // Start logo animation
    _logoController.forward();

    // Progress timer updates UI and triggers finish when duration elapses.
    final int tickMs = 50;
    final int ticks = (widget.duration.inMilliseconds / tickMs).ceil();
    int currentTick = 0;

    _timer = Timer.periodic(Duration(milliseconds: tickMs), (t) {
      currentTick++;
      setState(() {
        _progress = (currentTick / ticks).clamp(0.0, 1.0);
      });
      if (currentTick >= ticks) {
        _timer.cancel();
        _finish();
      }
    });
  }

  Future<void> _finish() async {
    // Allow a little fade-out for a smoother transition.
    final Duration? oldDuration = _logoController.duration;
    _logoController.duration = const Duration(milliseconds: 400);
    await _logoController.reverse();
    _logoController.duration = oldDuration;
    if (!mounted) return;

    if (widget.onInitializationComplete != null) {
      widget.onInitializationComplete!();
      return;
    }

    if (widget.nextRoute != null) {
      try {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(widget.nextRoute!);
        }
      } catch (e) {
        // If navigation fails (no route), do nothing.
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = widget.backgroundGradient ??
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: _buildLogo(context),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  _buildProgressIndicator(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.28;
    if (widget.logoAsset != null && widget.logoAsset!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.logoAsset!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return FlutterLogo(size: size);
          },
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(0, 8),
              blurRadius: 18,
            ),
          ],
        ),
        child: Center(
          child: FlutterLogo(size: size * 0.6),
        ),
      );
    }
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 160,
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 6,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${(_progress * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
