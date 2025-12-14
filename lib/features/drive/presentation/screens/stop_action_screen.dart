import 'dart:io';

import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/core/router/app_router.dart';
import 'package:driver_app/features/drive/domain/entities/stop.dart';
import 'package:driver_app/features/drive/domain/entities/location.dart';
import 'package:driver_app/features/drive/presentation/providers/job_provider.dart';
import 'package:driver_app/features/drive/presentation/providers/location_provider.dart';
import 'package:driver_app/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class StopActionScreen extends ConsumerStatefulWidget {
  final String jobId;
  final Stop stop;

  const StopActionScreen({
    super.key,
    required this.jobId,
    required this.stop,
  });

  @override
  ConsumerState<StopActionScreen> createState() => _StopActionScreenState();
}

class _StopActionScreenState extends ConsumerState<StopActionScreen> {
  String? _photoPath;
  LocationE? _location;
  bool _isLoadingLocation = false;

  Future<void> _takePhoto() async {
    final result = await context.push<String>(Routes.cameraAction);

    if (result != null) {
      setState(() {
        _photoPath = result;
      });
    }
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await ref.read(locationProvider.notifier).getCurrentLocation();
      
      if (location != null) {
        setState(() {
          _location = location;
        });
        
        if (mounted) {
          showSnackBar(context, AppStrings.successGettingLocation, SnackBarType.success);
        }
      } else {
        if (mounted) {
          showSnackBar(context, AppStrings.failedGetLocation, SnackBarType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error: $e', SnackBarType.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _completeStop() {
    ref.read(jobProvider.notifier).updateStopJob(
          widget.jobId,
          widget.stop.id,
          mediaPath: _photoPath,
          latitude: _location?.latitude,
          longitude: _location?.longitude,
          isCompleted: true,
        );

    context.pop();
    showSnackBar(context, AppStrings.successCompletingStop, SnackBarType.success);
  }

  Widget _buildStepCard({
    required int stepNumber,
    required String title,
    required String subtitle,
    required HeroIcons icon,
    required bool isCompleted,
    bool isLoading = false,
    required VoidCallback onTap,
    Widget? child,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: isCompleted ? null : onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? Theme.of(context).colorScheme.tertiary 
                          : Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? HeroIcon(
                              HeroIcons.check,
                              color: Theme.of(context).colorScheme.onSecondary,
                              size: AppSizes.iconXL,
                            )
                          : Text(
                              '$stepNumber',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: AppSizes.font5XL,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: AppSizes.font5XL,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingXS),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: AppSizes.fontL,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading) ...[
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 2,
                      ),
                    )
                  ] else if (!isCompleted) ...[
                    HeroIcon(
                      icon, 
                      color: Theme.of(context).colorScheme.secondary,
                      size: AppSizes.icon2XL,
                      style: HeroIconStyle.solid,
                    ),
                  ]
                ],
              ),
              if (child != null) ...[
                const SizedBox(height: AppSizes.paddingS),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppSizes.paddingS),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
              child: Image.file(
                File(_photoPath!),
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSizes.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.successTakingPhoto,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppSizes.font5XL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  TextButton.icon(
                    onPressed: _takePhoto,
                    icon: HeroIcon(
                      HeroIcons.arrowPath, 
                      color: Theme.of(context).colorScheme.secondary,
                      size: AppSizes.iconXL,
                    ),
                    label: Text(
                      AppStrings.retake,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: AppSizes.fontM,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: AppSizes.paddingS),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroIcon(
              HeroIcons.checkBadge, 
              color: Theme.of(context).colorScheme.tertiary
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.successConfirmLocation,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppSizes.font5XL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Lat: ${_location!.latitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: AppSizes.fontL,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    'Lng: ${_location!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: AppSizes.fontL,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (_location!.address != null) ...[
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      _location!.address!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: AppSizes.fontM,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _photoPath != null;
    final hasLocation = _location != null;
    final canComplete = hasPhoto && hasLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.stopActionTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL  - 2,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding2XL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: widget.stop.typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  border: Border.all(
                    color: widget.stop.typeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.paddingXS,
                        horizontal: AppSizes.paddingS, 
                      ),
                      decoration: BoxDecoration(
                        color: widget.stop.typeColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                      ),
                      child: Text(
                        widget.stop.typeLabel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: AppSizes.fontM,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroIcon(
                          HeroIcons.mapPin, 
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: AppSizes.iconXL, 
                          style: HeroIconStyle.solid,
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: Text(
                            widget.stop.address,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: AppSizes.font5XL,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),              
              const SizedBox(height: AppSizes.padding2XL),
              Text(
                '${AppStrings.steps}:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: AppSizes.fontXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              _buildStepCard(
                stepNumber: 1,
                title: AppStrings.takePhotoTitle,
                subtitle: AppStrings.takePhotoSubtitle,
                icon: HeroIcons.camera,
                isCompleted: hasPhoto,
                onTap: _takePhoto,
                child: hasPhoto ? _buildPhotoPreview() : null,
              ),
              const SizedBox(height: AppSizes.paddingL),
              _buildStepCard(
                stepNumber: 2,
                title: AppStrings.confirmLocationTitle,
                subtitle: AppStrings.confirmLocationSubtitle,
                icon: HeroIcons.mapPin,
                isCompleted: hasLocation,
                isLoading: _isLoadingLocation,
                onTap: _getLocation,
                child: hasLocation ? _buildLocationInfo() : null,
              ),
              const SizedBox(height: AppSizes.padding2XL),
              ElevatedButton(
                onPressed: canComplete ? _completeStop : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  disabledBackgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroIcon(
                      HeroIcons.checkBadge,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: AppSizes.iconL,
                      style: HeroIconStyle.solid,
                    ),
                    const SizedBox(width: AppSizes.paddingS),
                    Text(
                      AppStrings.finishStop,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: AppSizes.font5XL,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (!canComplete) ...[
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.paddingS),
                  child: Text(
                    AppStrings.completeStepOrder,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: AppSizes.fontS,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}