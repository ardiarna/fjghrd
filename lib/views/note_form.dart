import 'package:fjghrd/controllers/note_control.dart';
import 'package:fjghrd/models/note.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteForm extends StatelessWidget {
  final String id;
  const NoteForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteControl>();
    Note item = controller.listNote.firstWhere(
      (element) => element.id == id,
      orElse: () => Note(),
    );
    controller.txtId.text = item.id;
    controller.txtNama.text = item.nama;
    controller.txtTeks.text = item.teks;

    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AFwidget.formHeader('Form Ubah Note', icon: Icons.note_alt_outlined),
          AFwidget.barisText(
            label: 'Nama',
            controller: controller.txtNama,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: const Text('Teks'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: controller.txtTeks,
                    maxLines: 6,
                    minLines: 3,
                    keyboard: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AFwidget.tombol(
                  label: 'Batal',
                  color: Colors.orange,
                  onPressed: Get.back,
                  minimumSize: const Size(120, 40),
                ),
                const SizedBox(width: 20),
                AFwidget.tombol(
                  label: 'Simpan',
                  color: Colors.blue,
                  onPressed: controller.ubahData,
                  minimumSize: const Size(120, 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showNoteForm(String id) {
  AFwidget.dialog(
    NoteForm(id: id),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
