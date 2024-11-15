import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/tarif_efektif.dart';
import 'package:fjghrd/repositories/tarif_efektif_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TarifEfektifControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final TarifEfektifRepository _repo = TarifEfektifRepository();

  List<TarifEfektif> listTarifEfektif = [];

  late TextEditingController txtId, txtPersen, txtPenghasilan;
  String kategoriTER = '';

  Future<void> loadTarifEfektifs() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listTarifEfektif.clear();
      for (var data in hasil.daftar) {
        listTarifEfektif.add(TarifEfektif.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void inputForm(String id) {
    TarifEfektif item = id == '' ? TarifEfektif() : listTarifEfektif.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtPersen.text = item.persen.toString();
    txtPenghasilan.text = AFconvert.matNumber(item.penghasilan);
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
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} TER'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Kategori TER'),
                  ),
                  Expanded(
                    child: GetBuilder<TarifEfektifControl>(
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
            AFwidget.barisText(
              label: 'Penghasilan',
              controller: txtPenghasilan,
              isNumber: true,
            ),
            AFwidget.barisText(
              label: 'Tarif Pajak (%)',
              controller: txtPersen,
              isNumber: true,
              decimalDigits: 2,
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

  void hapusForm(TarifEfektif item) {
    AFwidget.formHapus(
      label: 'TER ${item.ter} penghasilan Rp. ${AFconvert.matNumber(item.penghasilan)}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(kategoriTER.isEmpty) {
        throw 'Kategori TER harus diisi';
      }
      if(txtPenghasilan.text.isEmpty) {
        throw 'Penghasilan harus diisi';
      }
      if(txtPersen.text.isEmpty) {
        throw 'Persen harus diisi';
      }
      var a = TarifEfektif(
        ter: kategoriTER,
        penghasilan: AFconvert.keInt(txtPenghasilan.text),
        persen: AFconvert.keDouble(txtPersen.text),

      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadTarifEfektifs();
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
      if(kategoriTER.isEmpty) {
        throw 'Kategori TER harus diisi';
      }
      if(txtPenghasilan.text.isEmpty) {
        throw 'Penghasilan harus diisi';
      }
      if(txtPersen.text.isEmpty) {
        throw 'Persen harus diisi';
      }
      var a = TarifEfektif(
        id: txtId.text,
        ter: kategoriTER,
        penghasilan: AFconvert.keInt(txtPenghasilan.text),
        persen: AFconvert.keDouble(txtPersen.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadTarifEfektifs();
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
        throw 'ID TER null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadTarifEfektifs();
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
    txtPersen = TextEditingController();
    txtPenghasilan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtPersen.dispose();
    txtPenghasilan.dispose();
    super.onClose();
  }
}
