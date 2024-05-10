import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/repositories/hari_libur_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HariLiburControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final HariLiburRepository _repo = HariLiburRepository();

  List<HariLibur> listHariLibur = [];
  Opsi filterTahun = Opsi(value: '${DateTime.now().year}', label: '${DateTime.now().year}');

  late TextEditingController txtId, txtNama, txtTanggal;

  Future<void> loadHariLiburs() async {
    var hasil = await _repo.findAll(tahun: filterTahun.value);
    if (hasil.success) {
      listHariLibur.clear();
      for (var data in hasil.daftar) {
        listHariLibur.add(HariLibur.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void tambahForm(BuildContext context) {
    txtId.text = '';
    txtNama.text = '';
    txtTanggal.text = AFconvert.matYMD(DateTime.now());
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.all(20),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const Text('Form Tambah Hari Libur',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tanggal'),
                  ),
                  Expanded(
                    child: AFwidget.textField(
                      marginTop: 0,
                      controller: txtTanggal,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.calendar_month),
                      ontap: () async {
                        var a = await AFwidget.pickDate(
                          context: context,
                          initialDate: AFconvert.keTanggal(txtTanggal.text),
                        );
                        if(a != null) {
                          txtTanggal.text = AFconvert.matYMD(a);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 11),
            barisText(
              label: 'Nama',
              controller: txtNama,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AFwidget.tombol(
                  label: 'Simpan',
                  color: Colors.blue,
                  onPressed: tambahData,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahForm(String id, BuildContext context) {
    var item = listHariLibur.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtNama.text = item.nama;
    txtTanggal.text = AFconvert.matYMD(item.tanggal);
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.all(20),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const Text('Form Ubah Hari Libur',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tanggal'),
                  ),
                  Expanded(
                    child: AFwidget.textField(
                      marginTop: 0,
                      controller: txtTanggal,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.calendar_month),
                      ontap: () async {
                        var a = await AFwidget.pickDate(
                          context: context,
                          initialDate: AFconvert.keTanggal(txtTanggal.text),
                        );
                        if(a != null) {
                          txtTanggal.text = AFconvert.matYMD(a);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 11),
            barisText(
              label: 'Nama',
              controller: txtNama,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AFwidget.tombol(
                  label: 'Hapus Data',
                  color: Colors.red,
                  onPressed: () {
                    hapusForm(item);
                  },
                ),
                AFwidget.tombol(
                  label: 'Simpan',
                  color: Colors.blue,
                  onPressed: ubahData,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(HariLibur item) {
    AFwidget.formHapus(
      label: 'hari libur ${item.nama}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      var a = HariLibur(
        nama: txtNama.text,
        tanggal: AFconvert.keTanggal('${txtTanggal.text} 08:00:00'),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadHariLiburs();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw 'ID tidak ditemukan';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      var a = HariLibur(
        id: txtId.text,
        nama: txtNama.text,
        tanggal: AFconvert.keTanggal('${txtTanggal.text} 08:00:00'),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadHariLiburs();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw 'ID Hari Libur null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadHariLiburs();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    int tahunNow = DateTime.now().year;
    var a = await AFcombobox.bottomSheet(
      listOpsi: List.generate(tahunNow-2019, (index) => Opsi(value: '${tahunNow-index}', label: '${tahunNow-index}')),
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  Widget barisText({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
    bool isTextArea = false
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        crossAxisAlignment: isTextArea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            padding: EdgeInsets.only(right: 15, top: isTextArea ? 15 : 0),
            child: Text(label),
          ),
          Expanded(
            child: AFwidget.textField(
              marginTop: 0,
              controller: controller,
              maxLines: isTextArea ? 4 : 1,
              minLines: isTextArea ? 2 : 1,
              keyboard: isTextArea ? TextInputType.multiline : TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtTanggal = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtTanggal.dispose();
    super.onClose();
  }
}
