import 'dart:io';
import 'package:driver_app/core/constants/app_sizes.dart';
import 'package:driver_app/core/constants/app_strings.dart';
import 'package:driver_app/core/router/app_router.dart';
import 'package:driver_app/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraActionScreen extends StatefulWidget {
  const CameraActionScreen({super.key});

  @override
  State<CameraActionScreen> createState() => _CameraActionScreenState();
}

class _CameraActionScreenState extends State<CameraActionScreen> {
  List<CameraDescription> cameras = [];
  CameraController? _controller;
  Future<void>? _initController;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      if (mounted) {
        showSnackBar(context, AppStrings.cameraNotFound, SnackBarType.error);
      }
    }

    final camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initController = _controller!.initialize();
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || _isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      await _initController;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = path.join(directory.path, fileName);

      final XFile image = await _controller!.takePicture();

      await File(image.path).copy(filePath);

      if (mounted) {
        final shouldUse = await context.push<bool>(Routes.photoPreview, extra: {'mediaPath': filePath});
 
        if (shouldUse == true) {
          if (mounted) {
            context.pop(filePath);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error: $e', SnackBarType.error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.cameraActionTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: AppSizes.font2XL  - 2,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: _controller == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<void>(
                future: _initController,
                builder: (context, snapshot) {
                  if (_controller == null || !_controller!.value.isInitialized) {
                    return Center(child: CircularProgressIndicator());
                  }
            
                  final size = _controller!.value.previewSize!;
            
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AspectRatio(
                            aspectRatio: size.height / size.width,
                            child: CameraPreview(_controller!),
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
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -(AppSizes.padding2XL),
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppStrings.appName,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                                          fontSize: 106.0,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'cursive'
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: _isTakingPicture ? null : _takePicture,
                                    child: Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.secondary,
                                          width: 4,
                                        ),
                                      ),
                                      child: _isTakingPicture
                                          ? Padding(
                                              padding: EdgeInsets.all(AppSizes.paddingL),
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context).colorScheme.secondary,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Container(
                                              margin: EdgeInsets.all(AppSizes.paddingXS),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
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
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                        strokeWidth: 2,
                      ),
                    );
                  }
                },
              ),
          ),
    );
  }
}