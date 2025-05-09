import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import '../bloc/viewer_cubit.dart';
import '../bloc/viewer_state.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:croppy/croppy.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Image sources - can be assets or memory images
  List<ImageProvider> images = [
    const AssetImage("assets/sheet1.png"),
    const AssetImage("assets/sheet2.png"),
  ];
  
  late Rect rect;
  bool _hasTriggeredCropper = false; // prevents duplicate calls

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: 500,
      height: 500,
    );
  }

  Future<void> _openCropper() async {
    try {
      final result = await showCupertinoImageCropper(
        context,
        imageProvider: images[0], // Use current image source
      );

      // Reset cropper trigger flag to allow cropping again
      setState(() {
        _hasTriggeredCropper = false;
      });

      // Handle cropping result
      if (result != null) {
        // Convert the cropped image to a memory image
        final byteData = await result.uiImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final imageMemory = MemoryImage(byteData.buffer.asUint8List());
          
          // Update the image source with the cropped version
          setState(() {
            images[0] = imageMemory;
          });
        }
      }
      
      // Return to initial state after cropping (whether successful or canceled)
      context.read<ViewerCubit>().resetToInitial();
    } catch (e) {
      print('Error during cropping: $e');
      setState(() {
        _hasTriggeredCropper = false;
      });
      // Also reset to initial state if there's an error
      context.read<ViewerCubit>().resetToInitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (TapDownDetails details) {
          if (!rect.inflate(20).contains(details.localPosition)) {
            print("user clicked outside of box");
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            BlocBuilder<ViewerCubit, ViewerState>(
              builder: (context, state) {
                if (state is ViewerStateCropper && !_hasTriggeredCropper) {
                  _hasTriggeredCropper = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _openCropper();
                  });
                }

                if (state is ViewerStateInitial) {
                  return TransformableBox(
                    rect: rect,
                    visibleHandles: {
                      HandlePosition.right,
                      HandlePosition.bottom,
                      HandlePosition.bottomRight
                    },
                    resizeModeResolver: () => ResizeMode.freeform,
                    clampingRect: Offset.zero & MediaQuery.sizeOf(context),
                    onChanged: (result, event) {
                      setState(() {
                        rect = result.rect;
                      });
                    },
                    contentBuilder: (context, rect, flip) {
                      return Image(
                        image: images[0],
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }

                return const SizedBox.shrink(); // placeholder
              },
            ),
            BlocBuilder<ViewerCubit, ViewerState>(
              builder: (context, state) {
                return Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ViewerCubit>().changeToCropMode();
                      },
                      child: const Text("Click Me To Crop"),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}