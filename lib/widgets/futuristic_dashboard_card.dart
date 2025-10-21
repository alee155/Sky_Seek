import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FuturisticDashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color primaryColor;
  final Color secondaryColor;
  final Color highlightColor;
  final double width;
  final double height;
  final bool showShine;

  const FuturisticDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.primaryColor = const Color(0xFF1A2038),
    this.secondaryColor = const Color(0xFF303854),
    this.highlightColor = Colors.tealAccent,
    this.width = 172,
    this.height = 85,
    this.showShine = true,
  });

  @override
  State<FuturisticDashboardCard> createState() =>
      _FuturisticDashboardCardState();
}

class _FuturisticDashboardCardState extends State<FuturisticDashboardCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _shineController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shineAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Create separate controllers for hover and shine
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Faster hover response
    );

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Shine effect duration
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    // Shine animation with its own controller
    _shineAnimation = Tween<double>(
      begin: -0.5,
      end: 1.5, // Safer range to avoid edge issues
    ).animate(CurvedAnimation(parent: _shineController, curve: Curves.linear));

    if (widget.showShine) {
      // Make the shine effect repeat continuously
      _shineController.repeat(period: const Duration(milliseconds: 2000));
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? _scaleAnimation.value : 1.0,
              child: Container(
                height: widget.height.h,
                width: widget.width.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.primaryColor, widget.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow:
                      _isHovered
                          ? [
                            BoxShadow(
                              color: widget.highlightColor.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ]
                          : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                ),
                child: Stack(
                  children: [
                    // Conditional shine effect
                    if (widget.showShine)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.r),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Transform.translate(
                                offset: Offset(
                                  constraints.maxWidth * _shineAnimation.value,
                                  0,
                                ),
                                child: Container(
                                  // Much wider shine effect
                                  width: constraints.maxWidth * 0.8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        widget.highlightColor.withOpacity(
                                          0.01,
                                        ), // Never use 0.0 opacity
                                        widget.highlightColor.withOpacity(
                                          0.7,
                                        ), // Slightly reduced
                                        widget.highlightColor.withOpacity(
                                          0.01,
                                        ), // Never use 0.0 opacity
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    // Border glow
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color:
                              _isHovered
                                  ? widget.highlightColor.withOpacity(0.8)
                                  : widget.secondaryColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SpaceGrotesk',
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color: widget.highlightColor
                                            .withOpacity(0.5),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isHovered) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Explore",
                                    style: TextStyle(
                                      color: widget.highlightColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color:
                                  _isHovered
                                      ? widget.highlightColor.withOpacity(0.2)
                                      : Colors.black12,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.icon,
                              color:
                                  _isHovered
                                      ? widget.highlightColor
                                      : Colors.white70,
                              size: 22.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Angular corner accent
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: widget.highlightColor.withOpacity(0.6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            bottomRight: Radius.circular(6.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
