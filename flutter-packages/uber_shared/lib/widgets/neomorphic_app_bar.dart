import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic app bar with elevated appearance and soft shadows
class NeomorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final Color? backgroundColor;

  const NeomorphicAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.elevation = 4,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark.withOpacity(0.2),
            offset: Offset(elevation, elevation),
            blurRadius: elevation * 2,
          ),
          BoxShadow(
            color: AppTheme.shadowLight.withOpacity(0.2),
            offset: Offset(-elevation, -elevation),
            blurRadius: elevation * 2,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              if (leading != null)
                Container(
                  margin: const EdgeInsets.all(8),
                  child: leading,
                ),
              if (title != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                      child: title!,
                    ),
                  ),
                ),
              if (actions != null)
                ...actions!.map(
                  (action) => Container(
                    margin: const EdgeInsets.all(8),
                    child: action,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}