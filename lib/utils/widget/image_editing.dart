import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:siscom_operasional/utils/constans.dart';

class ImageEditingScreen extends StatefulWidget {
  File imageFile;

  ImageEditingScreen({required this.imageFile});

  @override
  _ImageEditingScreenState createState() => _ImageEditingScreenState();
}

class _ImageEditingScreenState extends State<ImageEditingScreen> {
  PainterController _controller = PainterController();
  final isLoading = false.obs;
  TextEditingController captionController = TextEditingController();
  bool isDrawingMode = false;
  bool isTextMode = false;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initPainterController();
  }

  void _initPainterController() {
    _controller = PainterController(
      settings: const PainterSettings(
        freeStyle: FreeStyleSettings(
          color: Colors.red,
          strokeWidth: 5.0,
        ),
        text: TextSettings(),
      ),
    );

    _loadImageToPainter();
  }

  Future<void> _loadImageToPainter() async {
    final imageBytes = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(imageBytes);
    _controller.background = decodedImage.backgroundDrawable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white, size: 24),
            onPressed: _controller.undo,
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 24),
            onPressed: _finalizeEditing,
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            FlutterPainter(controller: _controller),
            if (isLoading.value)
              const Center(child: CircularProgressIndicator()),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: captionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Tulis Pesan...",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _buildToolbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return BottomAppBar(
      color: Colors.black.withOpacity(0.7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.crop, color: Colors.white),
            onPressed: _cropImage,
          ),
          IconButton(
            icon: Icon(Icons.brush,
                color: isDrawingMode
                    ? _controller.settings.freeStyle.color
                    : Colors.white),
            onPressed: () {
              setState(() {
                isDrawingMode = true;
                isTextMode = false;
              });
              _controller.settings = _controller.settings.copyWith(
                freeStyle: _controller.settings.freeStyle.copyWith(
                  mode: FreeStyleMode.draw,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.text_fields,
                color: isTextMode
                    ? _controller.settings.freeStyle.color
                    : Colors.white),
            onPressed: () {
              setState(() {
                isDrawingMode = false;
                isTextMode = true;
              });
              _controller.addText();
            },
          ),
          IconButton(
            icon: const Icon(Icons.color_lens, color: Colors.white),
            onPressed: _pickColor,
          ),
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: Constanst.colorBlack,
            toolbarWidgetColor: Constanst.colorWhite,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: '',
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          widget.imageFile = File(croppedFile.path);
          _initPainterController(); // Reload sizes after cropping
        });
      }
    } catch (e) {
      print("Error during image cropping: $e");
    }
  }

  Future<void> _pickColor() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Warna'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _controller.settings.freeStyle.color,
              onColorChanged: (color) {
                _controller.settings = _controller.settings.copyWith(
                  freeStyle: _controller.settings.freeStyle.copyWith(
                    color: color,
                  ),
                );
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _finalizeEditing() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final image = img.decodeImage(Uint8List.fromList(bytes))!;
      Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      isLoading.value = true;
      final renderedImage = await _controller.renderImage(imageSize);
      final imageBytes =
          await renderedImage.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory.systemTemp;
      final editedImagePath = '${directory.path}/edited_image.png';
      final editedImageFile = File(editedImagePath);
      await editedImageFile.writeAsBytes(imageBytes!.buffer.asUint8List());

      Get.back(
          result: {'file': editedImageFile, 'caption': captionController.text});
    } catch (e) {
      print('Failed to edit image: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
