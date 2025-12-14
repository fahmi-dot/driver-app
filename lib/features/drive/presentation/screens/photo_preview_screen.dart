import 'dart:io';

import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String mediaPath;

  const PhotoPreviewScreen({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.photoPreviewTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL - 2,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.file(
                File(mediaPath),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusL)),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              ),
                              padding: EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                            ),
                            icon: HeroIcon(
                              HeroIcons.arrowPath,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: AppSizes.iconXL,
                            ),
                            label: Text(
                              AppStrings.retake,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: AppSizes.fontL,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingL),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.onSurface,
                              padding: EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                            ),
                            icon: HeroIcon(
                              HeroIcons.check,
                              color: Theme.of(context).colorScheme.onSecondary,
                              size: AppSizes.iconXL,
                            ),
                            label: Text(
                              AppStrings.usePhoto,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: AppSizes.fontL,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSizes.padding2XL,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.6),
                    fontSize: AppSizes.fontXL,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'cursive'
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}