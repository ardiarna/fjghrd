import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/beranda_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangelogView extends StatefulWidget {
  const ChangelogView({super.key});

  static const String appVersion = 'v2.2.1';

  @override
  State<ChangelogView> createState() => _ChangelogViewState();
}

class _ChangelogViewState extends State<ChangelogView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AFwidget.pageHeader(
          onBack: () {
            final hc = Get.find<HomeControl>();
            hc.tabId = 0;
            hc.kontener = BerandaView();
            hc.update();
          },
          title: 'CHANGELOG',
          icon: Icons.history_outlined,
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVersion(
                    version: 'v2.2.1',
                    date: '18 Sep 2026',
                    emoji: '🔧',
                    subtitle: 'Stabilisasi Desktop & Perbaikan Fungsional',
                    items: [
                      'Optimalisasi Desktop (Windows/macOS): Memperbaiki kendala layar putih (blank) dan form tidak responsif saat aplikasi pertama kali dibuka (mengatasi race condition pada inisiasi window).',
                      'Export Excel Skala Besar: Peningkatan batas waktu (timeout) penerimaan data menjadi 120 detik untuk memastikan unduhan Laporan Jadwal Cuti karyawan yang memakan waktu lama tidak lagi terputus di tengah jalan.',
                      'Fleksibilitas Input Kehadiran: Penyesuaian sistem validasi pada form Penghasilan; kini memungkinkan pengisian Jumlah IDR senilai 0 khusus untuk tipe penghasilan "Kehadiran".',
                      'Format Kolom Periode: Penyederhanaan tampilan kolom "Periode" pada seluruh tabel data grid (Penghasilan, Potongan, Lembur, dll) menggunakan format singkatan kapital (contoh: JAN \'26) agar lebih ringkas dan rapi.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v2.2.0',
                    date: '17 Sep 2026',
                    emoji: '✨',
                    subtitle: 'Pembaruan Identitas & Penyesuaian UI',
                    items: [
                      'Ikon Aplikasi: Pembaruan ikon launcher aplikasi untuk berbagai platform (Web, Windows, dan macOS).',
                      'Logo & Header: Integrasi logo FRATEKINDO (versi putih) pada header halaman Beranda, Laporan, dan Sidebar untuk identitas yang lebih kuat.',
                      'Sidebar Footer Redesign: Tata letak baru pada bagian bawah sidebar dengan tombol Keluar (Logout) yang tersambung penuh dengan tepi layar.',
                      'Tampilan Versi: Penyesuaian label penunjuk versi aplikasi menjadi format teks minimalis di pojok kiri bawah.',
                      'Perbaikan Bug: Resolusi kendala navigasi kembali (back button) dan fungsi scroll controller pada halaman Changelog.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v2.1.0',
                    date: '16 Sep 2026',
                    emoji: '✨',
                    subtitle: 'Fitur Baru & Peningkatan UI',
                    items: [
                      'Role-Based Access Control: Pembatasan fitur UI dan akses laporan berdasarkan role (Admin vs User).',
                      'Unduhan Laporan (PDF & Excel): Integrasi download PDF dan Excel untuk Rekap Payroll, Slip Gaji, Daftar Cuti, hingga Cuti Khusus CIC.',
                      'Akurasi Cuti: Dukungan nilai desimal pada pengisian lama hari cuti untuk akomodasi half-day.',
                      'Master Data: Penambahan ceklis "Cuti Bersama" pada manajemen Hari Libur.',
                      'Tabel Karyawan: Penambahan kolom Usia (Thn) pada tabel Karyawan Aktif dan Calon Karyawan.',
                      'Status Warna Identitas: Header halaman detail profil berubah warna otomatis — Putih (Aktif), Hijau Muda (Calon), Merah Muda (Ex Karyawan).',
                      'Run Payroll Pintar: Filter pencarian karyawan, Check/Uncheck All, dan info Terpilih / Periode / Cut-Off di header eksekusi.',
                      'Sinkronisasi Ikon: Ikon tombol header, sub-payroll, dan seluruh menu sidebar kini diseragamkan dan konsisten.',
                      'Tabel Auto-Fit: Kolom Nama pada seluruh halaman master data (Jabatan, Divisi, Area, Hari Libur, Jenis Cuti Khusus, dll) kini otomatis menyesuaikan lebarnya.',
                      'UI & Layout Revamp: Penyegaran Bottom Navigation Bar, lebar & ikon Sidebar Drawer, serta berbagai penyesuaian padding dan spacing.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v2.0.0',
                    date: '04 Sep 2026',
                    emoji: '🚀',
                    subtitle: 'Optimasi & Arsitektur (Major Update)',
                    items: [
                      'Separation of Concerns (SoC): Refactoring besar-besaran pada struktur sistem (Karyawan, Payroll, Cuti) menjadi arsitektur "Best Practice" yang lebih bersih dan aman.',
                      'Performa Rendering: Peningkatan manajemen state (GetBuilder) dengan ID spesifik untuk menghindari re-rendering yang tidak perlu.',
                      'Sistem Validasi Universal: Pembuatan kelas ValidationException untuk menstandardisasi peringatan kesalahan pengisian data di seluruh modul.',
                      'Cut-Off Payroll Dinamis: Pengaturan batas (cut-off) periode payroll secara individual per-karyawan.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.6.0',
                    date: '01 Sep 2026',
                    emoji: '✨',
                    subtitle: 'Modul Cuti Lanjutan & Training',
                    items: [
                      'CIC Cuti: Rilis penuh modul manajemen Cuti Khusus CIC beserta form dan validasinya.',
                      'Modul Training: Penambahan fitur pencatatan dan manajemen Pelatihan (Training) Karyawan beserta riwayatnya.',
                      'Manajemen Karyawan Cerdas: Perbaikan fitur muat data antar daftar Karyawan Aktif, Calon, dan Ex Karyawan.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.5.0',
                    date: '28 Ags 2026',
                    emoji: '✨',
                    subtitle: 'Modul Cuti & Cuti Masal',
                    items: [
                      'Manajemen Cuti Terpadu: Peluncuran modul Cuti, Ijin, Cuti Masal, Form Pengajuan, dan Riwayat Cuti.',
                      'Logika Jatah Cuti: Implementasi aturan "Memiliki Jatah", "Pindah ke Minus", dan "Boleh Minus" pada saldo cuti.',
                      'Cetak Laporan Cuti: Penambahan fitur ekspor riwayat cuti ke Excel.',
                      'Tabel Cuti: Penambahan pelacakan detil durasi cuti terpakai dan hari kalender.',
                      'UI Theme Baru: Perubahan tema background dan komponen UI visual yang lebih modern.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.4.2',
                    date: '04 Jun 2025',
                    emoji: '🔧',
                    subtitle: 'Penyempurnaan PHK & Demografi',
                    items: [
                      'Uang PHK Tambahan: Modul Uang PHK mendukung kolom keterangan tambahan',
                      'Pembatalan PHK: Fitur membatalkan (Batal/Delete) status PHK karyawan untuk mengembalikannya menjadi aktif.',
                      'Keluarga & Demografi: Penambahan formulir pencatatan anggota keluarga dan data demografi karyawan secara detail.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.4.1',
                    date: '11 Feb 2025',
                    emoji: '🔧',
                    subtitle: 'Penyempurnaan Modul Gaji',
                    items: [
                      'Update Form Penghasilan & Potongan: Perbaikan tampilan dan logika input Gaji Pokok.',
                      'Pemuatan Data Otomatis: Inisialisasi pemuatan data karyawan secara otomatis saat modul dibuka.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.4.0',
                    date: '17 Sep 2024',
                    emoji: '✨',
                    subtitle: 'Dasbor & Profil Karyawan Lengkap',
                    items: [
                      'Beranda Summary Dashboard: Penambahan modul dasbor utama yang menampilkan rangkuman demografi, status kerja, area, dan kehadiran karyawan.',
                      'Calon Karyawan: Rilis modul khusus (pipeline) untuk mencatat data Calon Karyawan terpisah dari karyawan aktif.',
                      'Medical & Kompensasi Hadir: Penyempurnaan modul Medical dan penambahan hitungan potongan kompensasi kehadiran (jam).',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.3.0',
                    date: '22 Jul 2024',
                    emoji: '✨',
                    subtitle: 'Laporan, Penghasilan & Potongan Dinamis',
                    items: [
                      'Komponen Gaji Dinamis: Peluncuran modul khusus Penghasilan Tambahan dan Potongan Tambahan.',
                      'Alert Warning: Penambahan dialog peringatan untuk kesalahan pengisian data di berbagai modul.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.2.0',
                    date: '24 Jun 2024',
                    emoji: '✨',
                    subtitle: 'Pajak PPh21 & Tarif Efektif',
                    items: [
                      'Modul Pajak PPh21: Peluncuran mesin kalkulasi PPh21 otomatis terintegrasi langsung dengan Payroll.',
                      'Master PTKP: Penambahan master data Penghasilan Tidak Kena Pajak (PTKP).',
                      'Tarif Efektif (TER): Penambahan modul Tarif Efektif Rata-Rata sesuai kebijakan perpajakan terbaru.',
                      'Excel Rekap Pajak: Ekspor khusus daftar Rekap PPh21 per karyawan.',
                      'NPWP Karyawan: Penambahan field NPWP pada data profil karyawan.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.1.0',
                    date: '30 Mei 2024',
                    emoji: '✨',
                    subtitle: 'Medical, Overtime & Run Payroll',
                    items: [
                      'Modul Lembur (Overtime): Penambahan fitur input lembur karyawan.',
                      'Modul Medical: Penambahan fitur klaim dan reimbursement kesehatan.',
                      'Modul On-Call / Customer: Implementasi perhitungan uang On-Call.',
                      'Run Payroll: Peluncuran modul utama "Run Payroll" untuk kalkulasi gaji dan pengiriman data ke backend.',
                      'Modul Report Awal: Rilis halaman laporan pertama untuk Rekap Payroll.',
                      'Excel Slip Gaji: Ekspor Slip Gaji karyawan ke format Excel.',
                    ],
                  ),
                  _buildVersion(
                    version: 'v1.0.0',
                    date: '03 Mei 2024',
                    emoji: '🚀',
                    subtitle: 'Rilis Awal (Initial Release)',
                    items: [
                      'Arsitektur Dasar: Fondasi awal pengembangan sistem HRD FRATEKINDO.',
                      'Master Data Utama: Manajemen Jabatan, Divisi, Area, Hari Libur, Agama, dan Pendidikan.',
                      'Data Karyawan Induk: Pencatatan biodata dasar, NIK, alamat, NPWP, status karyawan (PKWT/PKWTT), Jenis Kelamin, dan Timeline Masa Kerja.',
                      'Master Upah & Hari Libur: Setup awal komponen Upah (Gaji Pokok) dan kalender Hari Libur.',
                      'PHK Dasar: Modul Pemutusan Hubungan Kerja (PHK) awal.',
                    ],
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersion({
    required String version,
    required String date,
    required String emoji,
    required String subtitle,
    required List<String> items,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 16)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFCBD5E1),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        version,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...items.map((item) {
                    final parts = item.split(':');
                    if (parts.length >= 2) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black87),
                                  children: [
                                    TextSpan(
                                      text: '${parts[0]}: ',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: parts.sublist(1).join(':').trim()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.bold)),
                          Expanded(child: Text(item, style: const TextStyle(color: Colors.black87))),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
