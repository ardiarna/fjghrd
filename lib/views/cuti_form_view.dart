import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/af_database.dart';

class CutiFormView extends StatelessWidget {
  final String formType;
  CutiFormView({super.key, required this.formType});

  final CutiControl controller = Get.put(CutiControl());

  @override
  Widget build(BuildContext context) {
    controller.formType = formType;
    String title = 'Form Cuti';
    if(formType == 'IJIN') title = 'Form Ijin';


    return Column(
      children: [
        AFwidget.formHeader('$title ${controller.filterTahun.label}'),
        Expanded(
          child: GetBuilder<CutiControl>(
            builder: (_) {
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const SizedBox(height: 10),
                  _buildKaryawanSelector(),
                  if(controller.selectedKaryawan != null) ...[
                    _buildKaryawanInfo(),

                    AFwidget.barisText(
                      controller: controller.txtTanggalKembali,
                      label: 'Tgl Masuk Kembali',
                      readOnly: true,
                      ontap: () async {
                        DateTime? picked = await AFwidget.pickDate(
                          context: context,
                          initialDate: controller.txtTanggalKembali.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(controller.txtTanggalKembali.text) : DateTime.now(),
                        );
                        if (picked != null) {
                          controller.txtTanggalKembali.text = AFconvert.matDate(picked);
                          controller.update();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    if(formType == 'CUTI_MASAL') ...[
                      _buildMasalChecklist(context),
                      _buildUnpaidChecklist(context),
                    ],
                    if(formType == 'CUTI' || formType == 'IJIN') ...[
                      _buildTahunanChecklist(context),
                      if(formType == 'CUTI') ...[
                        _buildKhususChecklist(context),
                      ]
                    ],
                    if(formType == 'CUTI') ...[
                        _buildUnpaidChecklist(context),
                        _buildGantiLiburChecklist(context),
                    ],
                  ],
                  const SizedBox(height: 30),
                ],
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: GetBuilder<CutiControl>(
            builder: (_) {
              bool isSubmittable = controller.canSubmit;
              return Row(
                children: [
                  if(controller.currentId != '') ...[
                    AFwidget.tombol(
                      label: 'Hapus',
                      color: Colors.red,
                      onPressed: () {
                          controller.hapusData(controller.currentId);
                      },
                      minimumSize: const Size(100, 40),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.print, size: 16),
                      label: const Text('Cetak'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, minimumSize: const Size(100, 40)),
                      onPressed: () async {
                          AFwidget.loading();
                          var hasil = await AFdatabase.download(url: 'cuti/excel/form/${controller.currentId}');
                          Get.back();
                          if(hasil.success) {
                            AFwidget.formWarning(
                              label: 'Form Cuti telah berhasil di-download. Silakan periksa direktori Download Anda (${hasil.message})',
                              warna: Colors.green,
                              ikon: Icons.info,
                            );
                          } else {
                            AFwidget.formWarning(label: 'Gagal men-download form cuti. [${hasil.message}]');
                          }
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                  Expanded(
                    child: Text(
                      controller.debugCanSubmitReason, 
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                  AFwidget.tombol(
                    label: 'Batal',
                    color: Colors.orange,
                    onPressed: Get.back,
                    minimumSize: const Size(120, 40),
                  ),
                  const SizedBox(width: 20),
                  AFwidget.tombol(
                    label: 'Simpan',
                    color: isSubmittable ? Colors.blue : Colors.grey,
                    onPressed: isSubmittable ? () {
                        controller.submitForm();
                    } : null,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }

  Widget _buildKaryawanSelector() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
        child: Row(
            children: [
                SizedBox(width: 150, child: Text('Pilih Karyawan')),
                Expanded(
                    child: AFwidget.comboField(
                      value: controller.selectedKaryawan?.nama ?? '',
                      label: '',
                      warnaBackground: controller.currentId != '' ? Colors.grey.shade200 : null,
                      onTap: controller.currentId != '' ? null : () async {
                        var a = await controller.pilihKaryawan(value: controller.selectedKaryawan?.id ?? '');
                        if(a != null && a.value != controller.selectedKaryawan?.id) {
                          controller.setKaryawan(Karyawan.fromMap(a.data!));
                        }
                      },
                    ),
                ),
            ]
        )
    );
  }

  Widget _buildKaryawanInfo() {
    Karyawan k = controller.selectedKaryawan!;
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
        child: Row(
            children: [
                SizedBox(width: 150),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${k.nama}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Bagian/Divisi: ${k.divisi.nama} / ${k.area.nama}'),
                          Text('Jabatan: ${k.jabatan.nama}'),
                          Text('NIK: ${k.nik}'),
                          Text('Status: ${k.statusKerja.nama}'),
                          Text('Tgl Masuk: ${AFconvert.matDate(k.tanggalMasuk)}'),
                        ],
                      ),
                    )
                )
            ]
        )
    );
  }

  
  Widget _buildMasalChecklist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: controller.cekMasal,
                    onChanged: (controller.currentId != '') ? null : (val) {
                      controller.cekMasal = val ?? false;
                      controller.update();
                    },
                  ),
                  const Text('Cuti Masal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if (controller.cekMasal) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35, top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Lama Cuti (Hari)')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtLamaMasal, readOnly: controller.currentId != '',
                                  label: '',
                                  keyboard: TextInputType.number,
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      (() {
                          int mx = AFconvert.keInt(controller.txtLamaMasal.text);
                          return _buildDateSelector(context, 'Tanggal Cuti', controller.tglMasal, max: mx, readOnly: controller.currentId != '');
                      })(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Keterangan')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtKetMasal,
                                  label: '',
                                  onchanged: (val) { controller.update(); },
                                ),
                            )
                        ]
                      ),
                    ]
                  )
                )
              ]
            ]
          )
        )
      )
    );
  }

  Widget _buildTahunanChecklist(BuildContext context) {
    bool disableCheckbox = false;
    if (formType == 'IJIN' && controller.hasJatah) {
      disableCheckbox = true; // Cannot uncheck
    }
    if (!controller.hasJatah) {
      disableCheckbox = true; // Cannot check (both CUTI and IJIN)
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: controller.cekTahunan,
                    onChanged: (disableCheckbox || controller.currentId != '') ? null : (val) {
                      controller.cekTahunan = val ?? false;
                      controller.update();
                    },
                  ),
                  const Text('1. Cuti Tahunan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if (!controller.hasJatah && controller.selectedKaryawan != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 45, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jatah cuti tahunan periode ${controller.filterTahun.label} belum diinput untuk karyawan ini.',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          controller.inputJatahForm('', 
                            defaultKaryawanId: controller.selectedKaryawan?.id,
                            defaultKaryawanNama: controller.selectedKaryawan?.nama,
                            defaultTahun: controller.filterTahun.value,
                          );
                        },
                        child: const Text('Input Sekarang'),
                      ),
                    ],
                  ),
                ),
              ],
              if(controller.cekTahunan) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Column(
                    children: [
                      _infoRow('Hak cuti tahunan periode ${controller.filterTahun.label}', '${controller.totalHakCuti} Hari'),
                      _infoRow('Cuti Yang Sudah Diambil', '${controller.sudahDiambil} Hari'),
                      _infoRow('Cuti Masal; Idul Fitri/Natal/Bersama', '${controller.cutiMasal} Hari'),
                      _infoRow('Cuti Yang Belum Diambil', '${controller.belumDiambil} Hari'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Cuti Yang Akan Diambil')),
                            SizedBox(
                              width: 100,
                              child: AFwidget.textField(
                                controller: controller.txtAkanDiambil, readOnly: controller.currentId != '',
                                keyboard: TextInputType.number,
                                suffix: const Padding(padding: EdgeInsets.only(top: 15), child: Text('Hari')),
                                inputformatters: [
                                  CurrencyTextInputFormatter.currency(
                                    symbol: '',
                                    decimalDigits: 0,
                                  ),
                                ],
                                onchanged: (val) {
                                  controller.hitungSisa();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      _infoRow('Sisa Hak Cuti Tahunan', '${controller.sisaHakCuti} Hari'),
                      const SizedBox(height: 10),
                      (() {
                        int mx = AFconvert.keInt(controller.txtAkanDiambil.text);
                        return _buildDateSelector(context, 'Tanggal Cuti', controller.tglTahunan, max: mx, readOnly: controller.currentId != '');
                      })(),
                      const SizedBox(height: 10),
                      Row(
                          children: [
                              SizedBox(width: 150, child: Text('Keterangan')),
                              Expanded(
                                  child: AFwidget.textField(
                                    controller: controller.txtKetTahunan,
                                    label: '',
                                  onchanged: (val) { controller.update(); },
                                  ),
                              )
                          ]
                      )
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKhususChecklist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: controller.cekKhusus,
                    onChanged: (controller.currentId != '') ? null : (val) {
                      controller.cekKhusus = val ?? false;
                      controller.update();
                    },
                  ),
                  const Text('2. Cuti Khusus Tanggungan Perusahaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if(controller.cekKhusus) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Jenis Cuti Khusus')),
                            Expanded(
                                child: AFwidget.comboField(
                                  value: controller.jenisKhusus?.label ?? '',
                                  label: '',
                                  warnaBackground: controller.currentId != '' ? Colors.grey.shade200 : null,
                                  onTap: controller.currentId != '' ? null : () async {
                                    var a = await controller.pilihJenisKhusus(value: controller.jenisKhusus?.value ?? '');
                                    if(a != null && a.value != controller.jenisKhusus?.value) {
                                      controller.jenisKhusus = a;
                                      var dbData = a.data;
                                      int lama = AFconvert.keInt(dbData?['lama_hari']);
                                      controller.satuanKhusus = AFconvert.keString(dbData?['satuan']);
                                      controller.txtLamaKhusus.text = lama == 0 ? '' : lama.toString();
                                      controller.update();
                                    }
                                  },
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text(controller.satuanKhusus == 'bulan' ? 'Lama Cuti (Bulan)' : 'Lama Cuti (Hari)')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtLamaKhusus, readOnly: controller.currentId != '',
                                  label: '',
                                  keyboard: TextInputType.number,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  onchanged: (val) {
                                    controller.update();
                                  }
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      (() {
                          int lm = AFconvert.keInt(controller.txtLamaKhusus.text);
                          bool isRange = lm > 5 || controller.satuanKhusus == 'bulan';
                          if (isRange) {
                              return Column(
                                  children: [
                                      Row(
                                          children: [
                                              SizedBox(width: 150, child: Text('Tanggal Awal')),
                                              Expanded(
                                                  child: AFwidget.textField(
                                                      controller: controller.txtTglAwalKhusus,
                                                      label: '',
                                                      readOnly: true,
                                                      ontap: () async {
                                                          DateTime? picked = await AFwidget.pickDate(
                                                              context: context,
                                                              initialDate: controller.txtTglAwalKhusus.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(controller.txtTglAwalKhusus.text) : DateTime.now(),
                                                          );
                                                          if(picked != null) {
                                                              if(controller.isTanggalDuplicate(picked, skipKategori: 'KHUSUS')) {
                                                                  AFwidget.snackbar('Sebagian tanggal bentrok dengan kategori lain');
                                                              } else {
                                                                  controller.txtTglAwalKhusus.text = AFconvert.matDate(picked);
                                                                  controller.update();
                                                              }
                                                          }
                                                      }
                                                  )
                                              )
                                          ]
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                          children: [
                                              SizedBox(width: 150, child: Text('Tanggal Akhir')),
                                              Expanded(
                                                  child: AFwidget.textField(
                                                      controller: controller.txtTglAkhirKhusus,
                                                      label: '',
                                                      readOnly: true,
                                                      ontap: () async {
                                                          DateTime? picked = await AFwidget.pickDate(
                                                              context: context,
                                                              initialDate: controller.txtTglAkhirKhusus.text.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(controller.txtTglAkhirKhusus.text) : DateTime.now(),
                                                          );
                                                          if(picked != null) {
                                                              if(controller.isTanggalDuplicate(picked, skipKategori: 'KHUSUS')) {
                                                                  AFwidget.snackbar('Sebagian tanggal bentrok dengan kategori lain');
                                                              } else {
                                                                  controller.txtTglAkhirKhusus.text = AFconvert.matDate(picked);
                                                                  controller.update();
                                                              }
                                                          }
                                                      }
                                                  )
                                              )
                                          ]
                                      )
                                  ]
                              );
                          } else {
                              return _buildDateSelector(context, 'Tanggal Cuti', controller.tglKhusus, max: lm, readOnly: controller.currentId != '');
                          }
                      })(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Keterangan')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtKetKhusus,
                                  label: '',
                                  onchanged: (val) { controller.update(); },
                                ),
                            )
                        ]
                      )
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnpaidChecklist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: controller.cekUnpaid,
                    onChanged: (controller.currentId != '') ? null : (val) {
                      controller.cekUnpaid = val ?? false;
                      controller.update();
                    },
                  ),
                  const Text('3. Cuti Diluar Tanggungan Perusahaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if(controller.cekUnpaid) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Jenis Unpaid Leave')),
                            Expanded(
                                child: AFwidget.comboField(
                                  value: controller.jenisUnpaid?.label ?? '',
                                  label: '',
                                  warnaBackground: controller.currentId != '' ? Colors.grey.shade200 : null,
                                  onTap: controller.currentId != '' ? null : () async {
                                    var a = await controller.pilihJenisUnpaid(value: controller.jenisUnpaid?.value ?? '');
                                    if(a != null && a.value != controller.jenisUnpaid?.value) {
                                      controller.jenisUnpaid = a;
                                      controller.update();
                                    }
                                  },
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Lama Cuti (Hari)')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtLamaUnpaid, readOnly: controller.currentId != '',
                                  label: '',
                                  keyboard: TextInputType.number,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  onchanged: (val) {
                                    controller.update();
                                  }
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      (() {
                          int mx = AFconvert.keInt(controller.txtLamaUnpaid.text);
                          return _buildDateSelector(context, 'Tanggal Cuti', controller.tglUnpaid, max: mx, readOnly: controller.currentId != '');
                      })(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Keterangan')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtKetUnpaid,
                                  label: '',
                                  onchanged: (val) { controller.update(); },
                                ),
                            )
                        ]
                      )
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGantiLiburChecklist(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: controller.cekGantiLibur,
                    onChanged: (controller.currentId != '') ? null : (val) {
                      controller.cekGantiLibur = val ?? false;
                      controller.update();
                    },
                  ),
                  const Text('4. Penggantian Hari Libur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              if(controller.cekGantiLibur) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Lama Cuti (Hari)')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtLamaGantiLibur, readOnly: controller.currentId != '',
                                  label: '',
                                  keyboard: TextInputType.number,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  onchanged: (val) {
                                    controller.update();
                                  }
                                ),
                            )
                        ]
                      ),
                      const SizedBox(height: 10),
                      (() {
                          int mx = AFconvert.keInt(controller.txtLamaGantiLibur.text);
                          return _buildDateSelector(context, 'Tanggal Penggantian', controller.tglGantiLibur, max: mx, readOnly: controller.currentId != '');
                      })(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                            SizedBox(width: 150, child: Text('Keterangan')),
                            Expanded(
                                child: AFwidget.textField(
                                  controller: controller.txtKetGantiLibur,
                                  label: '',
                                  onchanged: (val) { controller.update(); },
                                ),
                            )
                        ]
                      )
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, String label, List<DateTime> dates, {int max = 0, bool readOnly = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(label),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(dates.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children: dates.map((d) => Chip(
                    label: Text(AFconvert.matDate(d)),
                    onDeleted: readOnly ? null : () {
                      dates.remove(d);
                      controller.update();
                    },
                  )).toList(),
                ),
              (readOnly || max <= 0 || dates.length >= max)
              ? const SizedBox()
              : Padding(
                  padding: dates.isNotEmpty ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Tanggal'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () async {
                      DateTime? picked = await AFwidget.pickDate(
                        context: context,
                        initialDate: DateTime.now(),
                      );
                      if(picked != null) {
                        bool exists = controller.isTanggalDuplicate(picked);
                        if(exists) {
                          AFwidget.snackbar('Tanggal tersebut sudah dipilih (termasuk di kategori lain)');
                        } else {
                          dates.add(picked);
                          controller.update();
                        }
                      }
                    },
                  ),
                ),
              if (max > 0 && dates.length < max)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '⚠️ Jumlah tanggal cuti (${dates.length}) kurang dari lama cuti ($max hari).',
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              if (dates.length > max)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '⛔ Jumlah tanggal cuti (${dates.length}) melebihi lama cuti ($max hari). Silakan hapus tanggal berlebih.',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
