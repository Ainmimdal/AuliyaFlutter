import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for uploading images to Firebase Storage
class ImageUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Upload an image file to Firebase Storage
  /// Returns the download URL or null if upload fails
  /// 
  /// [localPath] - Local file path of the image
  /// [folder] - Subfolder name (e.g., 'children', 'treats', 'goals')
  static Future<String?> uploadImage(String localPath, {String folder = 'images'}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('ImageUploadService: No authenticated user');
        return null;
      }
      
      final file = File(localPath);
      if (!file.existsSync()) {
        print('ImageUploadService: File does not exist: $localPath');
        return null;
      }
      
      // Create unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = localPath.split('.').last;
      final fileName = '${timestamp}_$folder.$extension';
      
      // Upload to users/{uid}/{folder}/{filename}
      final ref = _storage.ref().child('users/${user.uid}/$folder/$fileName');
      
      // Upload with metadata
      final metadata = SettableMetadata(
        contentType: 'image/$extension',
        customMetadata: {'uploadedAt': DateTime.now().toIso8601String()},
      );
      
      final uploadTask = ref.putFile(file, metadata);
      
      // Wait for upload to complete
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('ImageUploadService: Uploaded to $downloadUrl');
      
      return downloadUrl;
    } catch (e) {
      print('ImageUploadService: Upload failed: $e');
      return null;
    }
  }
  
  /// Delete an image from Firebase Storage by URL
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
        return false;
      }
      
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('ImageUploadService: Deleted $imageUrl');
      return true;
    } catch (e) {
      print('ImageUploadService: Delete failed: $e');
      return false;
    }
  }
}
