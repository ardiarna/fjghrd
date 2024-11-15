import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/repositories/ptkp_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PtkpControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final PtkpRepository _repo = PtkpRepository();

  List<Ptkp> listPtkp = [];

  late TextEditingController txtId, txtKode, txtJumlah;
  String kategoriTER = '';

  Future<void> loadPtkps() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listPtkp.clear();
      for (var data in hasil.daftar) {
        listPtkp.add(Ptkp.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void inputForm(String id) {
    Ptkp item = id == '' ? Ptkp() : listPtkp.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtKode.text = item.kode;
    txtJumlah.text = AFconvert.matNumber(item.jumlah);
    kategoriTER = item.ter;
    AFwidget.dialog(
      Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} PTKP'),
            AFwidget.barisText(
              label: 'Kode',
              controller: txtKode,
            ),
            AFwidget.barisText(
              label: 'Jumlah',
              controller: txtJumlah,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Kategori TER'),
                  ),
                  Expanded(
                    child: GetBuilder<PtkpControl>(
                      builder: (_) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: 'A',
                              groupValue: kategoriTER,
                              onChanged: (a) {
                                if(a != null && a != kategoriTER) {
                                  kategoriTER = a;
                                  update();
                                }
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('TER A'),
                            ),
                            Radio<String>(
                              value: 'B',
                              groupValue: kategoriTER,
                              onChanged: (a) {
                                if(a != null && a != kategoriTER) {
                                  kategoriTER = a;
                                  update();
                                }
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('TER B'),
                            ),
                            Radio<String>(
                              value: 'C',
                              groupValue: kategoriTER,
                              onChanged: (a) {
                                if(a != null && a != kategoriTER) {
                                  kategoriTER = a;
                                  update();
                                }
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('TER C'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  id == '' ? Container() :
                  AFwidget.tombol(
                    label: 'Hapus Data',
                    color: Colors.red,
                    onPressed: () {
                      hapusForm(item);
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
                    onPressed: id == '' ? tambahData : ubahData,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(Ptkp item) {
    AFwidget.formHapus(
      label: 'PTKP ${item.kode}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtKode.text.isEmpty) {
        throw 'Kode harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah harus diisi';
      }
      if(kategoriTER.isEmpty) {
        throw 'Kategori TER harus diisi';
      }

      var a = Ptkp(
        kode: txtKode.text,
        ter: kategoriTER,
        jumlah: AFconvert.keInt(txtJumlah.text),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadPtkps();
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
        throw 'ID harus diisi';
      }
      if(txtKode.text.isEmpty) {
        throw 'Kode harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah harus diisi';
      }
      if(kategoriTER.isEmpty) {
        throw 'Kategori TER harus diisi';
      }

      var a = Ptkp(
        id: txtId.text,
        kode: txtKode.text,
        ter: kategoriTER,
        jumlah: AFconvert.keInt(txtJumlah.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPtkps();
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
        throw 'ID PTKP null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPtkps();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtKode = TextEditingController();
    txtJumlah = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtKode.dispose();
    txtJumlah.dispose();
    super.onClose();
  }
}
