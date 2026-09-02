import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/potongan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/upah_repository.dart';

class GajiForm extends StatefulWidget {
  const GajiForm({super.key});

  @override
  State<GajiForm> createState() => _GajiFormState();
}

class _GajiFormState extends State<GajiForm> {
  late TextEditingController txtGaji;
  late TextEditingController txtUangMakan;
  late bool makanHarian;
  final controller = Get.find<PotonganControl>();
  final UpahRepository repo = UpahRepository();

  @override
  void initState() {
    super.initState();
    txtGaji = TextEditingController(text: AFconvert.matNumber(controller.upah.gaji));
    txtUangMakan = TextEditingController(text: AFconvert.matNumber(controller.upah.uangMakan));
    makanHarian = controller.upah.makanHarian;
  }

  @override
  void dispose() {
    txtGaji.dispose();
    txtUangMakan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          AFwidget.barisText(
            label: 'Jumlah Gaji',
            controller: txtGaji,
            isNumber: true,
            labelWidth: 200,
          ),
          AFwidget.barisText(
            label: 'Jumlah Uang Makan',
            controller: txtUangMakan,
            isNumber: true,
            labelWidth: 200,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 200,
                  child: Text('Jenis Uang Makan'),
                ),
                Expanded(
                  child: RadioGroup<bool>(
                    groupValue: makanHarian,
                    onChanged: (a) {
                      if(a != null && a != makanHarian) {
                        setState(() {
                          makanHarian = a;
                        });
                      }
                    },
                    child: Row(
                      children: const [
                        Radio<bool>(value: true),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                          child: Text('Harian'),
                        ),
                        Radio<bool>(value: false),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                          child: Text('Tetap'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
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
                  onPressed: () async {
                    if(txtGaji.text.isEmpty) {
                      AFwidget.formWarning(label: 'Gaji harus diisi');
                      return;
                    }
                    if(txtUangMakan.text.isEmpty) {
                      AFwidget.formWarning(label: 'Uang Makan harus diisi');
                      return;
                    }
                    var a = Upah(
                      karyawanId: controller.karyawan.id,
                      gaji: AFconvert.keInt(txtGaji.text),
                      uangMakan: AFconvert.keInt(txtUangMakan.text),
                      makanHarian: makanHarian,
                    );
                    AFwidget.loading();
                    var hasil = await repo.create(a.karyawanId, a.toMap());
                    Get.back();
                    if(hasil.success) {
                      Get.back();
                      AFwidget.snackbar(hasil.message);
                      controller.upah.gaji = a.gaji;
                      controller.upah.uangMakan = a.uangMakan;
                      controller.upah.makanHarian = a.makanHarian;
                      controller.hitungJumlahIdr(controller.txtHari.text);
                      controller.update();
                    } else {
                      AFwidget.formWarning(label: hasil.message);
                    }
                  },
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

void showGajiForm(BuildContext context) {
  AFwidget.dialog(
    const GajiForm(),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
