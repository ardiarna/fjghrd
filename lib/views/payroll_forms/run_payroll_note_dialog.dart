import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunPayrollNoteDialog extends StatefulWidget {
  const RunPayrollNoteDialog({super.key});

  @override
  State<RunPayrollNoteDialog> createState() => _RunPayrollNoteDialogState();
}

class _RunPayrollNoteDialogState extends State<RunPayrollNoteDialog> {
  final PayrollControl controller = Get.find<PayrollControl>();
  late TextEditingController txtNote;
  final TextEditingController txtSearch = TextEditingController();
  late Set<String> selectedKaryawanIds;

  @override
  void initState() {
    super.initState();
    txtNote = TextEditingController(text: controller.runPayrollNote);

    var listKaryawanDipilih = controller.listKaryawan.where((e) => e.dipilih).toList();

    if (controller.runPayrollNoteHasBeenSaved) {
      selectedKaryawanIds = Set<String>.from(controller.runPayrollNoteKaryawanIds);
    } else {
      selectedKaryawanIds = Set<String>.from(listKaryawanDipilih.map((e) => e.id));
    }
  }

  @override
  void dispose() {
    txtNote.dispose();
    txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listKaryawanDipilih = controller.listKaryawan.where((e) => e.dipilih).toList();
    var keyword = txtSearch.text.toLowerCase().trim();
    var filteredList = keyword.isEmpty
        ? listKaryawanDipilih
        : listKaryawanDipilih.where((k) {
            return k.nama.toLowerCase().contains(keyword) ||
                k.area.kode.toLowerCase().contains(keyword) ||
                k.jabatan.nama.toLowerCase().contains(keyword);
          }).toList();

    bool allSelected = listKaryawanDipilih.isNotEmpty &&
        listKaryawanDipilih.every((e) => selectedKaryawanIds.contains(e.id));

    return Container(
      width: 650,
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 70, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Note
                const Text(
                  'Note Slip Gaji :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: txtNote,
                  minLines: 3,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan isi note disini...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header List Karyawan & Tombol Pilih Semua
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Karyawan (${selectedKaryawanIds.length}/${listKaryawanDipilih.length}) :',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF334155),
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        setState(() {
                          if (allSelected) {
                            selectedKaryawanIds.clear();
                          } else {
                            selectedKaryawanIds =
                                Set<String>.from(listKaryawanDipilih.map((e) => e.id));
                          }
                        });
                      },
                      icon: Icon(
                        allSelected ? Icons.deselect : Icons.select_all,
                        size: 16,
                      ),
                      label: Text(
                        allSelected ? 'Batal Semua' : 'Pilih Semua',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Search Bar Karyawan
                TextField(
                  controller: txtSearch,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: txtSearch.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              txtSearch.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    hintText: 'Cari nama / area / jabatan...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // List Karyawan
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: filteredList.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada karyawan yang sesuai',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: filteredList.length,
                            separatorBuilder: (context, idx) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (context, idx) {
                              final k = filteredList[idx];
                              final isChecked = selectedKaryawanIds.contains(k.id);
                              return CheckboxListTile(
                                value: isChecked,
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                activeColor: Colors.blue,
                                title: Text(
                                  k.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                subtitle: Text(
                                  '${k.area.kode} - ${k.jabatan.nama}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedKaryawanIds.add(k.id);
                                    } else {
                                      selectedKaryawanIds.remove(k.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    if (controller.runPayrollNoteHasBeenSaved ||
                        controller.runPayrollNote.isNotEmpty) ...[
                      AFwidget.tombol(
                        label: 'Hapus Note',
                        color: Colors.red,
                        onPressed: () {
                          controller.resetRunPayrollNote();
                          Get.back();
                          controller.update(['grid_payroll_actions', 'runpayroll_root']);
                        },
                        minimumSize: const Size(110, 40),
                      ),
                    ],
                    const Spacer(),
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: () => Get.back(),
                      minimumSize: const Size(100, 40),
                    ),
                    const SizedBox(width: 15),
                    AFwidget.tombol(
                      label: 'Simpan',
                      color: Colors.blue,
                      onPressed: () {
                        final noteVal = txtNote.text.trim();
                        if (noteVal.isEmpty) {
                          AFwidget.formWarning(
                            label: 'Note tidak boleh kosong. Gunakan tombol Hapus jika ingin menghapus note.',
                          );
                          return;
                        }
                        controller.runPayrollNote = noteVal;
                        controller.runPayrollNoteKaryawanIds =
                            Set<String>.from(selectedKaryawanIds);
                        controller.runPayrollNoteHasBeenSaved = true;
                        Get.back();
                        controller.update(['grid_payroll_actions', 'runpayroll_root']);
                      },
                      minimumSize: const Size(100, 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AFwidget.formHeader('Isi Note Slip Gaji', icon: Icons.note_alt_outlined),
        ],
      ),
    );
  }
}

void showRunPayrollNoteDialog() {
  AFwidget.dialog(
    const RunPayrollNoteDialog(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: EdgeInsets.zero,
  );
}
