import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:sizer/sizer.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    required this.onTap,
  });

  final Function(ImageSource source) onTap;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => onTap(ImageSource.camera),
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: w * 0.40,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              color: Colors.grey,
              dashPattern: const [8, 4],
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    const Icon(Icons.camera_alt, size: 55, color: Colors.grey),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Kamera'.tr,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onTap(ImageSource.gallery),
          child: SizedBox(
            width: w * 0.40,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              color: Colors.grey,
              dashPattern: const [8, 4],
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: 12),
                    Icon(Icons.photo, size: 55, color: Colors.grey),
                    SizedBox(
                      height: 12,
                    ),
                    Text("Galeri"),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
