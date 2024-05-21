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
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void tambahForm() {
    txtId.text = '';
    txtNama.text = '';
    txtAlamat.text = '';
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
            const Text('Form Tambah Customer',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Nama'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtNama,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Alamat'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtAlamat,
                  ),
                )
              ],
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
    var item = listCustomer.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtNama.text = item.nama;
    txtAlamat.text = item.alamat;
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
            const Text('Form Ubah Customer',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Nama'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtNama,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Alamat'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtAlamat,
                  ),
                )
              ],
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
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
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
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
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
