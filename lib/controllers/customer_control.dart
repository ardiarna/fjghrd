import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/repositories/customer_repository.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final CustomerRepository _repo = CustomerRepository();

  List<Customer> listCustomer = [];

  late TextEditingController txtId, txtNama, txtAlamat;

  Future<void> loadCustomers() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listCustomer.clear();
      for (var data in hasil.daftar) {
        listCustomer.add(Customer.fromMap(data));
      }
      update();
    }
  }

  void inputForm(String id) {
    Customer item = id == '' ? Customer() : listCustomer.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtNama.text = item.nama;
    txtAlamat.text = item.alamat;
    AFwidget.dialog(
      Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Customer'),
            AFwidget.barisText(
              label: 'Nama',
              controller: txtNama,
            ),
            AFwidget.barisText(
              label: 'Alamat',
              controller: txtAlamat,
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

  void hapusForm(Customer item) {
    AFwidget.formHapus(
      label: 'customer ${item.nama}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }

      var a = Customer(
        nama: txtNama.text,
        alamat: txtAlamat.text,
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadCustomers();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw 'ID harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }

      var a = Customer(
        id: txtId.text,
        nama: txtNama.text,
        alamat: txtAlamat.text,
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadCustomers();
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
    try {
      if(id == '') {
        throw 'ID Customer null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadCustomers();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtAlamat = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtAlamat.dispose();
    super.onClose();
  }
}
