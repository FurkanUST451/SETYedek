import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/work_model.dart';
import '../../../data/repositories/work_repository.dart';
import '../../app/user_controller.dart';

class FreelancerUploadWorkController extends GetxController {
  FreelancerUploadWorkController({WorkRepository? repository})
      : _repo = repository ?? Get.find<WorkRepository>();

  final WorkRepository _repo;

  final titleController = TextEditingController();
  final studioController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<WorkType> selectedType = WorkType.video.obs;
  final Rxn<File> pickedFile = Rxn<File>();
  final RxBool pickedIsVideo = false.obs;
  final RxBool isSubmitting = false.obs;

  void selectType(WorkType type) => selectedType.value = type;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (picked == null) return;
    pickedFile.value = File(picked.path);
    pickedIsVideo.value = false;
  }

  Future<void> pickVideo() async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked == null) return;
    pickedFile.value = File(picked.path);
    pickedIsVideo.value = true;
  }

  void clearMedia() {
    pickedFile.value = null;
    pickedIsVideo.value = false;
  }

  Future<bool> submit() async {
    final title = titleController.text.trim();
    final studio = studioController.text.trim();

    if (title.isEmpty || studio.isEmpty) {
      Get.snackbar('Eksik bilgi', 'Proje ismi ve imza alanlarını doldur',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    final file = pickedFile.value;
    if (file == null) {
      Get.snackbar('Eksik medya', 'Bir görsel ya da video seç',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    final user = Get.find<UserController>().currentUser;
    if (user == null) return false;

    isSubmitting.value = true;
    try {
      final workId = FirebaseFirestore.instance.collection('works').doc().id;
      final ext = pickedIsVideo.value ? 'mp4' : 'jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('work_uploads')
          .child('${user.id}_$workId.$ext');
      await ref.putFile(file);
      final mediaUrl = await ref.getDownloadURL();

      final work = WorkModel(
        id: workId,
        title: title,
        studio: studio,
        type: selectedType.value,
        freelancerId: user.id,
        description:
            descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
        mediaUrl: mediaUrl,
        isVideo: pickedIsVideo.value,
        createdAt: DateTime.now(),
      );
      await _repo.createWork(work);
      return true;
    } catch (_) {
      Get.snackbar('Hata', 'Yükleme başarısız oldu, tekrar dene',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    studioController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
