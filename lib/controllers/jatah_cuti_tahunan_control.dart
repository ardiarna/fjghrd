import 'package:fjghrd/models/jatah_cuti_tahunan.dart';
import 'package:fjghrd/repositories/jatah_cuti_tahunan_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JatahCutiTahunanControl extends GetxController {
  final JatahCutiTahunanRepository _repo = JatahCutiTahunanRepository();

  List<JatahCutiTahunan> listData = [];
  Opsi filterTahun = Opsi(
    value: DateTime.now().year.toString(),
    label: DateTime.now().year.toString(),
  );
  String filterKaryawanId = '';

  List<Opsi> listKaryawan = [];
  Opsi? selectedKaryawan;
  Opsi? selectedTahunForm;

  late TextEditingController txtId, txtJumlahCuti;

  Future<void> loadData() async {
    var hasil = await _repo.findAll(
      karyawanId: filterKaryawanId,
      tahun: filterTahun.value,
    );
    if (hasil.success) {
      listData.clear();
      for (var data in hasil.daftar) {
        listData.add(JatahCutiTahunan.fromMap(data));
      }
      update();
    }
  }

  void inputForm(String id) {
    JatahCutiTahunan item = id == ''
        ? JatahCutiTahunan()
        : listData.where((e) => e.id == id).first;

    txtId.text = item.id;
    txtJumlahCuti.text = item.jumlahCuti == 0 ? '' : item.jumlahCuti.toString();

    if (id != '' && item.karyawan != null) {
      selectedKaryawan = Opsi(
        value: item.karyawanId,
        label: item.karyawan!.nama,
      );
    } else {
      selectedKaryawan = null;
    }

    if (id != '' && item.tahun.isNotEmpty) {
      selectedTahunForm = Opsi(value: item.tahun, label: item.tahun);
    } else {
      selectedTahunForm = null;
    }

    update();

    AFwidget.dialog(
      GetBuilder<JatahCutiTahunanControl>(
        builder: (ctrl) {
          return Container(
            width: 700,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AFwidget.formHeader('Form Jatah Cuti Tahunan'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: const Text('Karyawan'),
                      ),
                      Expanded(
                        child: AFwidget.comboField(
                          value: ctrl.selectedKaryawan?.label ?? '',
                          label: '',
                          onTap: () async {
                            var a = await ctrl.pilihKaryawan(
                                value: ctrl.selectedKaryawan?.value ?? '');
                            if (a != null) {
                              ctrl.selectedKaryawan = a;
                              ctrl.update();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: const Text('Tahun'),
                      ),
                      Expanded(
                        child: AFwidget.comboField(
                          value: ctrl.selectedTahunForm?.label ?? '',
                          label: '',
                          onTap: () async {
                            var a = await ctrl.pilihTahun(
                                value: ctrl.selectedTahunForm?.value ?? '');
                            if (a != null) {
                              ctrl.selectedTahunForm = a;
                              ctrl.update();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Jumlah Cuti',
                  controller: txtJumlahCuti,
                  isNumber: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      item.id == ''
                          ? Container()
                          : AFwidget.tombol(
                              label: 'Hapus Data',
                              color: Colors.red,
                              onPressed: () {
                                hapusData(item.id);
                              },
                              minimumSize: const Size(120, 40),
                            ),
                      const Spacer(),
                      AFwidget.tombol(
                        label: 'Batal',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 40),
                      AFwidget.tombol(
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: simpanData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> simpanData() async {
    try {
      if (selectedKaryawan == null) {
        throw 'Karyawan harus dipilih';
      }
      if (selectedTahunForm == null) {
        throw 'Tahun harus dipilih';
      }
      if (txtJumlahCuti.text.isEmpty) {
        throw 'Jumlah cuti harus diisi';
      }

      var body = {
        'karyawan_id': selectedKaryawan!.value,
        'tahun': selectedTahunForm!.value,
        'jumlah_cuti': AFconvert.keInt(txtJumlahCuti.text),
      };

      AFwidget.loading();
      var hasil = txtId.text == ''
          ? await _repo.create(body)
          : await _repo.update(txtId.text, body);
      Get.back();
      if (hasil.success) {
        loadData();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusData(String id) async {
    AFwidget.formHapus(
      label: 'Jatah Cuti Tahunan',
      aksi: () async {
        try {
          AFwidget.loading();
          var hasil = await _repo.delete(id);
          Get.back();
          if (hasil.success) {
            loadData();
            Get.back();
            Get.back();
            AFwidget.snackbar(hasil.message);
          } else {
            AFwidget.formWarning(label: hasil.message);
          }
        } catch (er) {
          AFwidget.formWarning(label: '$er');
        }
      },
    );
  }

  Future<void> loadListKaryawan() async {
    var hasil = await AFdatabase.send(
      url: 'karyawan?aktif=Y&sort_by=nama&sort_order=asc',
    );
    if (hasil.success) {
      listKaryawan.clear();
      for (var data in hasil.daftar) {
        listKaryawan.add(
          Opsi(
            value: AFconvert.keString(data['id']),
            label: AFconvert.keString(data['nama']),
            data: data,
          ),
        );
      }
      update();
    }
  }

  Future<Opsi?> pilihKaryawan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listKaryawan,
      valueSelected: value,
      judul: 'Pilih Karyawan',
    );
    return a;
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    List<Opsi> listTahun = [];
    int startTahun = 2020;
    for (int i = 0; i <= 15; i++) {
      listTahun.add(Opsi(
        value: (startTahun + i).toString(),
        label: (startTahun + i).toString(),
      ));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
    );
    return a;
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtJumlahCuti = TextEditingController();
    super.onInit();
    loadData();
    loadListKaryawan();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtJumlahCuti.dispose();
    super.onClose();
  }
}
