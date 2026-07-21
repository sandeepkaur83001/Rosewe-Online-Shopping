import 'dart:io';
import 'package:flutter_base/core/common_imports.dart';
import 'package:file_picker/file_picker.dart';

enum PickerType { image, video, document, any }

class FilePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from Camera or Gallery
  static Future<File?> pickImage({
    required ImageSource source,
    List<String>? allowedExtensions,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
      String extension = pickedFile.path.split('.').last.toLowerCase();
      if (!allowedExtensions.map((e) => e.toLowerCase()).contains(extension)) {
        printError("Invalid file type. Allowed: $allowedExtensions");
        return null;
      }
    }

    return File(pickedFile.path);
  }

  /// Pick a video from Camera or Gallery
  static Future<File?> pickVideo({required ImageSource source}) async {
    final XFile? pickedFile = await _picker.pickVideo(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// Pick documents or any file using FilePicker
  static Future<File?> pickDocument({
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: (allowedExtensions != null && allowedExtensions.isNotEmpty)
            ? FileType.custom
            : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      printError("FilePicker Error: $e");
    }
    return null;
  }

  /// Unified dialog to pick different types of files
  static void showPicker(
    BuildContext context, {
    required PickerType type,
    required Function(File? file) onFilePicked,
    List<String>? allowedExtensions,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == PickerType.image || type == PickerType.video || type == PickerType.any) ...[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(type == PickerType.video ? 'Take Video' : 'Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    File? file;
                    if (type == PickerType.video) {
                      file = await pickVideo(source: ImageSource.camera);
                    } else {
                      file = await pickImage(source: ImageSource.camera, allowedExtensions: allowedExtensions);
                    }
                    onFilePicked(file);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(type == PickerType.video ? 'Gallery (Video)' : 'Gallery (Photo)'),
                  onTap: () async {
                    Navigator.pop(context);
                    File? file;
                    if (type == PickerType.video) {
                      file = await pickVideo(source: ImageSource.gallery);
                    } else {
                      file = await pickImage(source: ImageSource.gallery, allowedExtensions: allowedExtensions);
                    }
                    onFilePicked(file);
                  },
                ),
              ],
              if (type == PickerType.document || type == PickerType.any)
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Document'),
                  onTap: () async {
                    Navigator.pop(context);
                    final file = await pickDocument(allowedExtensions: allowedExtensions);
                    onFilePicked(file);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
