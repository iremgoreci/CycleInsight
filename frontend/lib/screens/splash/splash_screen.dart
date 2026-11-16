import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/brand_mark.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhaseSpectrumMark(size: 56),
            SizedBox(height: AppSpacing.lg),
            BrandWordmark(showMark: false, fontSize: 22),
            SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
