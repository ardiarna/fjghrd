import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
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

  void tambahForm() {
    txtId.text = '';
    txtPersen.text = '';
    txtPenghasilan.text = '';
    kategoriTER = '';
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
            const Text('Form Tambah TER',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Kategori TER'),
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
            barisText(
              label: 'Penghasilan',
              controller: txtPenghasilan,
              isNumber: true,
            ),
            barisText(
              label: 'Tarif Pajak (%)',
              controller: txtPersen,
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

  void ubahForm(String id) {
    TarifEfektif item =listTarifEfektif.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtPersen.text = item.persen.toString();
    txtPenghasilan.text = AFconvert.matNumber(item.penghasilan);
    kategoriTER = item.ter;
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
            const Text('Form Ubah TER',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Kategori TER'),
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
            barisText(
              label: 'Penghasilan',
              controller: txtPenghasilan,
              isNumber: true,
            ),
            barisText(
              label: 'Tarif Pajak (%)',
              controller: txtPersen,
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

  Widget barisText({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
    bool isTextArea = false,
    bool isNumber = false,
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
              inputformatters: !isNumber ? null : [
                CurrencyTextInputFormatter.currency(
                  symbol: '',
                  decimalDigits: 0,
                ),
              ],
              textAlign: isNumber ? TextAlign.end : TextAlign.start,
            ),
          ),
        ],
      ),
    );
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
