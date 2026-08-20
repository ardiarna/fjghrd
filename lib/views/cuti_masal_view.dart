import 'package:fjghrd/controllers/cuti_masal_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CutiMasalView extends StatelessWidget {
  const CutiMasalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CutiMasalControl>(
      init: CutiMasalControl(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Form Cuti Masal'),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          ),
          body: Column(
            children: [
              _buildTopSection(context, controller),
              const Divider(thickness: 2),
              Expanded(
                child: _buildTableSection(context, controller),
              ),
              _buildBottomAction(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopSection(BuildContext context, CutiMasalControl controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 150, child: Text('Tahun Cuti')),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahun.value);
                            if(a != null) controller.ubahTahun(a);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(controller.filterTahun.label),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Keperluan',
                  controller: controller.txtKeperluan,
                  isTextArea: true,
                ),
                AFwidget.barisText(
                  label: 'Tgl Kembali',
                  controller: controller.txtTglKembali,
                  readOnly: true,
                  ontap: () async {
                    var a = await AFwidget.pickDate(context: context, 
                      initialDate: controller.txtTglKembali.text != '' ? DateFormat('dd-MM-yyyy').parse(controller.txtTglKembali.text) : DateTime.now(),
                    );
                    if(a != null) {
                      controller.txtTglKembali.text = DateFormat('dd-MM-yyyy').format(a);
                      controller.update();
                    }
                  }
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AFwidget.barisText(
                  label: 'Lama Hari',
                  controller: controller.txtLamaHariGlobal,
                  isNumber: true,
                  onchanged: (v) => controller.update(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 150, child: Text('Tanggal Cuti')),
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (var tgl in controller.listTanggalGlobal)
                              Chip(
                                label: Text(DateFormat('dd-MM-yyyy').format(tgl)),
                                onDeleted: () {
                                  controller.listTanggalGlobal.remove(tgl);
                                  controller.update();
                                },
                              ),
                            if (controller.listTanggalGlobal.length < AFconvert.keInt(controller.txtLamaHariGlobal.text))
                              ActionChip(
                                label: const Text('Tambah Tanggal'),
                                avatar: const Icon(Icons.add, size: 16),
                                onPressed: () async {
                                  var a = await AFwidget.pickDate(context: context, initialDate: DateTime.now());
                                  if (a != null) {
                                    if(controller.listTanggalGlobal.any((e) => e.year == a.year && e.month == a.month && e.day == a.day)) {
                                      AFwidget.snackbar('Tanggal sudah dipilih');
                                      return;
                                    }
                                    controller.listTanggalGlobal.add(a);
                                    controller.update();
                                  }
                                },
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      onPressed: controller.generateGlobal,
                      child: const Text('Generate ke Semua Karyawan'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(BuildContext context, CutiMasalControl controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataRowMinHeight: 60,
          dataRowMaxHeight: double.infinity,
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
          columns: [
            DataColumn(
              label: Checkbox(
                value: controller.checkSemua,
                onChanged: controller.toggleCheckSemua,
              )
            ),
            const DataColumn(label: Text('Nama Karyawan')),
            const DataColumn(label: Text('Jabatan')),
            const DataColumn(label: Text('Kuota Info')),
            const DataColumn(label: Text('Lama Hari')),
            const DataColumn(label: Text('Tanggal Cuti')),
            const DataColumn(label: Text('Alokasi & Sisa')),
          ],
          rows: controller.listKaryawan.map((k) {
            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) => !k.isChecked ? Colors.grey.withValues(alpha: 0.2) : null),
              cells: [
                DataCell(
                  Checkbox(
                    value: k.isChecked,
                    onChanged: (val) => controller.checkKaryawan(k, val),
                  )
                ),
                DataCell(Text(k.nama)),
                DataCell(Text(k.jabatan)),
                DataCell(
                  k.hasJatah
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hak: ${k.totalHakCuti}, Sisa: ${k.belumDiambil}', style: const TextStyle(fontSize: 12)),
                        Text('Diambil: ${k.sudahDiambil}, C.Masal: ${k.cutiMasalLama}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum ada jatah', style: TextStyle(color: Colors.red, fontSize: 12)),
                        InkWell(
                          onTap: () => controller.inputJatahKaryawan(k),
                          child: const Text('Input Jatah', style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
                        )
                      ],
                    )
                ),
                DataCell(
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      controller: k.txtLamaHari,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                      onChanged: (v) => controller.update(),
                    ),
                  )
                ),
                DataCell(
                  SizedBox(
                    width: 250,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (var tgl in k.inputDates)
                          Chip(
                            label: Text(DateFormat('dd-MM').format(tgl), style: const TextStyle(fontSize: 11)),
                            padding: const EdgeInsets.all(0),
                            onDeleted: () {
                              k.inputDates.remove(tgl);
                              controller.update();
                            },
                          ),
                        if (k.inputDates.length < k.inputLamaHari)
                          ActionChip(
                            label: const Text('+', style: TextStyle(fontSize: 11)),
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              var a = await AFwidget.pickDate(context: context, initialDate: DateTime.now());
                              if (a != null) {
                                if(k.inputDates.any((e) => e.year == a.year && e.month == a.month && e.day == a.day)) return;
                                k.inputDates.add(a);
                                controller.update();
                              }
                            },
                          )
                      ],
                    ),
                  )
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cuti Masal: ${k.splitCutiMasal} | Unpaid: ${k.splitUnpaid}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Sisa Akhir: ${k.sisaAkhir}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: k.sisaAkhir < 0 ? Colors.red : Colors.green),
                      )
                    ],
                  )
                ),
              ]
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomAction(CutiMasalControl controller) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AFwidget.tombol(
            label: 'Batal',
            color: Colors.orange,
            onPressed: Get.back,
            minimumSize: const Size(120, 40),
          ),
          const SizedBox(width: 20),
          AFwidget.tombol(
            label: 'Simpan',
            color: Colors.blue,
            onPressed: controller.simpanData,
            minimumSize: const Size(120, 40),
          ),
        ],
      ),
    );
  }
}
