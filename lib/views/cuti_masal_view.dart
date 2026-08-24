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
          body: Column(
            children: [
              AFwidget.pageHeader(
                title: 'FORM CUTI MASAL',
                icon: Icons.groups,
                onBack: () => Get.back(),
              ),
              _buildTopSection(context, controller),
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
                  label: 'Keterangan',
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
    // Custom Table to support sticky header and auto-expanding rows
    return LayoutBuilder(
      builder: (context, constraints) {
        double minTblWidth = 1000;
        double extraWidth = constraints.maxWidth > minTblWidth ? constraints.maxWidth - minTblWidth : 0;
        double namaWidth = 150 + extraWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth > minTblWidth ? constraints.maxWidth : minTblWidth),
            child: Column(
              children: [
                // HEADER
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Checkbox(
                          value: controller.checkSemua,
                          onChanged: controller.toggleCheckSemua,
                        ),
                      ),
                      SizedBox(width: namaWidth, child: const Text('Nama Karyawan', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 130, child: Text('Jabatan', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 150, child: Text('Kuota Info', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 80, child: Text('Lama Hari', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 280, child: Text('Tanggal Cuti', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(width: 160, child: Text('Alokasi & Sisa', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                // BODY
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: controller.listKaryawan.map((k) {
                        return Container(
                          decoration: BoxDecoration(
                            color: !k.isChecked ? Colors.grey.withValues(alpha: 0.1) : null,
                            border: const Border(bottom: BorderSide(color: Colors.black12)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Checkbox
                              SizedBox(
                                width: 50,
                                child: Checkbox(
                                  value: k.isChecked,
                                  onChanged: (val) => controller.checkKaryawan(k, val),
                                ),
                              ),
                              // Nama
                              SizedBox(
                                width: namaWidth,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: Text(k.nama),
                                ),
                              ),
                              // Jabatan
                              SizedBox(
                                width: 130,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: Text(k.jabatan),
                                ),
                              ),
                              // Kuota Info
                              SizedBox(
                                width: 150,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: k.hasJatah
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
                                              onTap: k.isChecked ? () => controller.inputJatahKaryawan(k) : null,
                                              child: const Text('Input Jatah', style: TextStyle(color: Colors.blue, fontSize: 12, decoration: TextDecoration.underline)),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                              // Lama Hari
                              SizedBox(
                                width: 80,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: TextFormField(
                                      controller: k.txtLamaHari,
                                      enabled: k.isChecked,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8)),
                                      onChanged: (v) => controller.update(),
                                    ),
                                  ),
                                ),
                              ),
                              // Tanggal Cuti
                              SizedBox(
                                width: 280,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      for (var tgl in k.inputDates)
                                        Chip(
                                          label: Text(DateFormat('dd-MM').format(tgl), style: const TextStyle(fontSize: 11)),
                                          padding: const EdgeInsets.all(0),
                                          onDeleted: k.isChecked ? () {
                                            k.inputDates.remove(tgl);
                                            controller.update();
                                          } : null,
                                        ),
                                      if (k.inputDates.length < k.inputLamaHari)
                                        ActionChip(
                                          label: const Text('+', style: TextStyle(fontSize: 11)),
                                          padding: const EdgeInsets.all(0),
                                          onPressed: k.isChecked ? () async {
                                            var a = await AFwidget.pickDate(context: context, initialDate: DateTime.now());
                                            if (a != null) {
                                              if(k.inputDates.any((e) => e.year == a.year && e.month == a.month && e.day == a.day)) return;
                                              k.inputDates.add(a);
                                              controller.update();
                                            }
                                          } : null,
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              // Alokasi & Sisa
                              SizedBox(
                                width: 160,
                                child: Opacity(
                                  opacity: k.isChecked ? 1.0 : 0.4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 12, color: Colors.black),
                                          children: [
                                            const TextSpan(text: 'Cuti Masal: '),
                                            TextSpan(text: '${k.splitCutiMasal}'),
                                            TextSpan(text: ' | Unpaid: ', style: TextStyle(color: k.splitUnpaid > 0 ? Colors.orange : Colors.black)),
                                            TextSpan(
                                              text: '${k.splitUnpaid}',
                                              style: TextStyle(color: k.splitUnpaid > 0 ? Colors.orange : Colors.black, fontWeight: k.splitUnpaid > 0 ? FontWeight.bold : FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 12, color: Colors.black),
                                          children: [
                                            TextSpan(text: 'Sisa Akhir: ', style: TextStyle(color: k.sisaAkhir == 0 ? Colors.black : (k.sisaAkhir > 0 ? Colors.green : Colors.red))),
                                            TextSpan(
                                              text: '${k.sisaAkhir}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: k.sisaAkhir == 0 ? Colors.black : (k.sisaAkhir > 0 ? Colors.green : Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
