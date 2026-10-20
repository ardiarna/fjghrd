import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/note.dart';
import 'package:fjghrd/repositories/note_repository.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class NoteControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final NoteRepository _repo = NoteRepository();

  RxList<Note> listNote = <Note>[].obs;

  late TextEditingController txtId, txtNama, txtTeks;

  Future<void> loadNotes() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listNote.assignAll(hasil.daftar.map<Note>((data) => Note.fromMap(data)).toList());
    }
  }

  Future<void> ubahData() async {
    try {
      if (txtId.text.isEmpty) {
        throw ValidationException('ID Note tidak ditemukan');
      }
      if (txtNama.text.trim().isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if (txtTeks.text.trim().isEmpty) {
        throw ValidationException('Teks harus diisi');
      }

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, {
        'nama': txtNama.text.trim(),
        'teks': txtTeks.text,
      });
      Get.back();
      if (hasil.success) {
        loadNotes();
        Get.back();
        authControl.masterDataUpdateTrigger.value++;
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtTeks = TextEditingController();
    loadNotes();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtTeks.dispose();
    super.onClose();
  }
}
