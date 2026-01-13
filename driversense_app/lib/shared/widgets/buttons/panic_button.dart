import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';

/// Large panic/emergency button
class PanicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final double size;

  const PanicButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.size = 100,
  });

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.heavyImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing background
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: widget.size + 20,
                height: widget.size + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withOpacity(0.2),
                ),
              ),
            ),
            // Main button
            Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: widget.isLoading ? null : _onTap,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
