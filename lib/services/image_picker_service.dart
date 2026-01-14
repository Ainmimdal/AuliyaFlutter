import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'image_upload_service.dart';

/// Service for picking, cropping, and optionally uploading images
class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();
  
  /// Pick an image from camera or gallery, crop to square, compress
  /// Returns the cropped image file path or null if cancelled
  static Future<String?> pickAndCropImage(BuildContext context) async {
    // Show source selection dialog
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: Color(0xFF6A1B9A)),
              ),
              title: const Text('Camera'),
              subtitle: const Text('Take a new photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: Color(0xFFE91E63)),
              ),
              title: const Text('Gallery'),
              subtitle: const Text('Choose from photos'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
    
    if (source == null) return null;
    
    // Pick image
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 90,
    );
    
    if (pickedFile == null) return null;
    
    // Crop to square
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color(0xFF6A1B9A),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
    
    return croppedFile?.path;
  }
  
  /// Pick, crop, and try to upload image to Firebase Storage
  /// If upload fails, returns local file path as fallback
  /// 
  /// [context] - Build context for showing dialogs
  /// [folder] - Storage folder (e.g., 'children', 'treats', 'goals')
  static Future<String?> pickCropAndUpload(BuildContext context, {String folder = 'images'}) async {
    final localPath = await pickAndCropImage(context);
    if (localPath == null) return null;
    
    // Show uploading indicator
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF6A1B9A)),
                  SizedBox(height: 16),
                  Text('Uploading...'),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Try to upload to Firebase Storage
    final downloadUrl = await ImageUploadService.uploadImage(localPath, folder: folder);
    
    // Dismiss loading dialog
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    
    // If upload succeeded, return URL and delete local file
    if (downloadUrl != null) {
      try {
        final file = File(localPath);
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (_) {}
      return downloadUrl;
    }
    
    // Upload failed - fallback to local path
    print('ImagePickerService: Firebase upload failed, using local path');
    return localPath;
  }
  
  /// Check if file exists at path
  static bool fileExists(String? path) {
    if (path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }
  
  /// Get ImageProvider from path (handles both local files and URLs)
  static ImageProvider? getImageProvider(String? path) {
    if (path == null || path.isEmpty) return null;
    
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }
    
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
    
    return null;
  }
}
