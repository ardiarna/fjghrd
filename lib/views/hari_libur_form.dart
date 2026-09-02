import 'package:fjghrd/controllers/hari_libur_control.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HariLiburForm extends StatelessWidget {
  final String id;
  const HariLiburForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HariLiburControl>();
    
    HariLibur item = id == '' ? HariLibur(tanggal: DateTime.now()) : controller.listHariLibur.where((element) => element.id == id).first;
    controller.txtId.text = item.id;
    controller.txtNama.text = item.nama;
    controller.txtTanggal.text = AFconvert.matYMD(item.tanggal);
    return Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} Hari Libur'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
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
                      controller: controller.txtTanggal,
                      readOnly: true,
                      prefixIcon: const Icon(Icons.calendar_month),
                      ontap: () async {
                        var a = await AFwidget.pickDate(
                          context: context,
                          initialDate: AFconvert.keTanggal(controller.txtTanggal.text),
                        );
                        if(a != null) {
                          controller.txtTanggal.text = AFconvert.matYMD(a);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            AFwidget.barisText(
              label: 'Nama',
              controller: controller.txtNama,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  item.id == '' ? Container() :
                  AFwidget.tombol(
                    label: 'Hapus Data',
                    color: Colors.red,
                    onPressed: () {
                      AFwidget.formHapus(
      label: 'hari libur ${item.nama}',
      aksi: () {
        controller.hapusData(item.id);
      },
    );
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
                    onPressed: controller.simpanData,
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

void showHariLiburForm(String id) {
  AFwidget.dialog(
    HariLiburForm(id: id),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
