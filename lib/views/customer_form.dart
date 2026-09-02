import 'package:fjghrd/controllers/customer_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerForm extends StatelessWidget {
  final String id;
  const CustomerForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerControl>();
    
    Customer item = id == '' ? Customer() : controller.listCustomer.where((element) => element.id == id).first;
    controller.txtId.text = item.id;
    controller.txtNama.text = item.nama;
    controller.txtAlamat.text = item.alamat;
    return Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} Customer'),
            AFwidget.barisText(
              label: 'Nama',
              controller: controller.txtNama,
            ),
            AFwidget.barisText(
              label: 'Alamat',
              controller: controller.txtAlamat,
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
      label: 'customer ${item.nama}',
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

void showCustomerForm(String id) {
  AFwidget.dialog(
    CustomerForm(id: id),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
