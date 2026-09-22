import 'package:flutter/material.dart';

import '../extensions/responsive_size_extension.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_durations.dart';

class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({super.key, required this.child});

  static ShimmerState? of(BuildContext context) => context.findAncestorStateOfType<ShimmerState>();

  @override
  State<Shimmer> createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController.unbounded(vsync: this);

  Listenable get animation => _controller;

  LinearGradient get gradient =>
      AppColors.shimmerGradient(_SlidingGradientTransform(_controller.value));

  RenderBox? get _box => context.findRenderObject() as RenderBox?;

  bool get isSized => _box?.hasSize ?? false;

  Size get size => _box!.size;

  Offset offsetOf(RenderBox descendant) => descendant.localToGlobal(Offset.zero, ancestor: _box);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = AppDimensions.shimmerRestValue;
    } else if (!_controller.isAnimating) {
      _controller.repeat(
        min: AppDimensions.shimmerSweepStart,
        max: AppDimensions.shimmerSweepEnd,
        period: AppDurations.shimmer,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SlidingGradientTransform extends GradientTransform {
  final double percent;

  const _SlidingGradientTransform(this.percent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * percent, 0, 0);
}

class ShimmerBox extends StatefulWidget {
  final double? width;
  final double? height;
  final double? radius;
  final bool circle;

  const ShimmerBox({super.key, this.width, this.height, this.radius, this.circle = false});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> {
  Listenable? _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation?.removeListener(_onTick);
    _animation = Shimmer.of(context)?.animation;
    _animation?.addListener(_onTick);
  }

  @override
  void dispose() {
    _animation?.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        shape: widget.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.circle
            ? null
            : BorderRadius.circular(widget.radius ?? AppDimensions.shimmerRadius.r),
      ),
    );

    final shimmer = Shimmer.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (shimmer == null || !shimmer.isSized || renderBox == null || !renderBox.hasSize) {
      return box;
    }

    final offset = shimmer.offsetOf(renderBox);
    final area = shimmer.size;

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (_) => shimmer.gradient.createShader(
        Rect.fromLTWH(-offset.dx, -offset.dy, area.width, area.height),
      ),
      child: box,
    );
  }
}

class ShimmerLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  final AlignmentGeometry alignment;

  const ShimmerLine({
    super.key,
    required this.widthFactor,
    required this.height,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: alignment,
      child: ShimmerBox(height: height),
    );
  }
}
