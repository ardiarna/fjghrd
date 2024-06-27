import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpahControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final UpahRepository _repo = UpahRepository();

  Karyawan current = Karyawan();
  List<Karyawan> listKaryawan = [];
  Opsi cariStaf = Opsi(value: 'Y', label: 'Staf');
  Map<String, int> totalKaryawanPerArea = {};

  late TextEditingController txtUangMakan;

  bool? makanHarian = false;
  bool? overtime = true;

  Future<void> loadKaryawans() async {
    var hasil = await _repo.findAll(isStaf: cariStaf.value);
    if (hasil.success) {
      listKaryawan.clear();
      totalKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        listKaryawan.add(k);
        if (totalKaryawanPerArea.containsKey('TOTAL KARYAWAN')) {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = totalKaryawanPerArea['TOTAL KARYAWAN']! + 1;
        } else {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = 1;
        }
        if (totalKaryawanPerArea.containsKey(k.area.nama)) {
          totalKaryawanPerArea[k.area.nama] = totalKaryawanPerArea[k.area.nama]! + 1;
        } else {
          totalKaryawanPerArea[k.area.nama] = 1;
        }
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void ubahForm(String karyawanId, BuildContext context) {
    current = listKaryawan.where((element) => element.id == karyawanId).first;
    txtUangMakan.text = AFconvert.matNumber(current.upah.uangMakan);
    makanHarian = current.upah.id.isEmpty ? null : current.upah.makanHarian;
    overtime = current.upah.id.isEmpty ? null : current.upah.overtime;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jabatan'),
                      ),
                      Expanded(
                        child: Text(': ${current.jabatan.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Masa Kerja'),
                      ),
                      Expanded(
                        child: Text(': ${AFconvert.matDate(current.tanggalMasuk)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Gaji Pokok Terakhir'),
                      ),
                      Expanded(
                        child: Text(': ${AFconvert.matNumber(current.upah.gaji)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisText(
                  label: 'Jumlah Uang Makan',
                  controller: txtUangMakan,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jenis Uang Makan'),
                      ),
                      Expanded(
                        child: GetBuilder<UpahControl>(
                          builder: (_) {
                            return Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: makanHarian,
                                  onChanged: (a) {
                                    if(a != null && a != makanHarian) {
                                      makanHarian = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Harian'),
                                ),
                                Radio<bool>(
                                  value: false,
                                  groupValue: makanHarian,
                                  onChanged: (a) {
                                    if(a != null && a != makanHarian) {
                                      makanHarian = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Tetap'),
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Status Overtime'),
                      ),
                      Expanded(
                        child: GetBuilder<UpahControl>(
                          builder: (_) {
                            return Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: overtime,
                                  onChanged: (a) {
                                    if(a != null && a != overtime) {
                                      overtime = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('OT'),
                                ),
                                Radio<bool>(
                                  value: false,
                                  groupValue: overtime,
                                  onChanged: (a) {
                                    if(a != null && a != overtime) {
                                      overtime = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('NON OT'),
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
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                        onPressed: ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Salary Karyawan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> ubahData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID karyawan tidak ditemukan';
      }
      if(txtUangMakan.text.isEmpty) {
        throw 'Uang Makan harus diisi';
      }
      if(makanHarian == null) {
        throw 'Silakan pilih apakah uang makan harian atau tidak';
      }
      if(overtime == null) {
        throw 'Silakan pilih status overtime ya atau tidak';
      }
      var a = Upah(
        id: current.upah.id,
        karyawanId: current.id,
        uangMakan: AFconvert.keInt(txtUangMakan.text),
        makanHarian: makanHarian ?? true,
        overtime: overtime ?? false,
      );
      AFwidget.loading();
      var hasil = Hasil();
      if(a.id == '') {
        hasil = await _repo.create(a.karyawanId, a.toMap());
      } else {
        hasil = await _repo.updateByKaryawanId(a.karyawanId, a.toMap());
      }
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<Opsi?> pilihStaf({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: [
        Opsi(value: 'Y', label: 'Staf'),
        Opsi(value: 'N', label: 'Non Staf'),
        Opsi(value: '', label: 'Staf & Non Staf'),
      ],
      valueSelected: value,
      judul: 'Pilih Jenis Karyawan',
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
            width: 200,
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
              inputformatters: [
                CurrencyTextInputFormatter.currency(
                  symbol: '',
                  decimalDigits: 0,
                ),
              ],
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    txtUangMakan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtUangMakan.dispose();
    super.onClose();
  }
}
