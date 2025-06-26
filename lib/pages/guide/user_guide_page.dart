import 'package:flutter/material.dart';
import 'package:ta_mobile/widgets/custom_floating_navbar.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A5099), // Warna biru latar belakang
      body: Stack(
        children: [
          Column(
            children: [
              // Header dengan Logo

              // Konten Panduan
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/LOGO.png', // Sesuaikan path logo
                          width: 100,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(
                                  "Panduan Penggunaan Aplikasi Power SmartIQ"),
                              SizedBox(height: 10),
                              _buildSectionTitle("1. Pendahuluan"),
                              _buildSectionContent(
                                "Power SmartIQ adalah aplikasi untuk memonitor dan mengontrol sistem kelistrikan secara efisien."
                                " Pastikan Anda memiliki koneksi internet yang stabil untuk kinerja optimal.",
                              ),
                              _buildSectionTitle("2. Instalasi dan Persiapan"),
                              _buildSubSectionTitle(
                                  "Unduh dan Instal Aplikasi"),
                              _buildSectionContent(
                                "Unduh Power SmartIQ di Google Play Store atau Apple Store.\n"
                                "Pastikan perangkat memiliki ruang penyimpanan yang cukup.",
                              ),
                              _buildSubSectionTitle("Koneksi Internet"),
                              _buildSectionContent(
                                "Pastikan perangkat terhubung dengan internet yang stabil untuk memastikan aplikasi bekerja dengan baik.",
                              ),
                              _buildSectionTitle(
                                  "3. Menambahkan Perangkat Monitoring"),
                              _buildSubSectionTitle("Buka Menu Monitoring"),
                              _buildSectionContent(
                                  "Di halaman utama aplikasi, pilih menu Monitoring."),
                              _buildSubSectionTitle("Tambahkan Perangkat Baru"),
                              _buildSectionContent(
                                "Tekan ikon (+), lalu masukkan ID perangkat dan Password yang diberikan oleh teknisi.",
                              ),
                              _buildSectionTitle(
                                  "4. Menghubungkan Perangkat Kontrol"),
                              _buildSubSectionTitle("Buka Menu Controlling"),
                              _buildSectionContent(
                                  "Dari halaman utama, pilih menu Controlling untuk mulai menghubungkan perangkat kontrol."),
                              _buildSubSectionTitle("Tambahkan Perangkat Baru"),
                              _buildSectionContent(
                                "Masukkan informasi perangkat seperti nama, alamat IP, dan kode akses dengan benar.",
                              ),
                              _buildSectionTitle("5. Tips dan Troubleshooting"),
                              _buildSubSectionTitle(
                                  "Perangkat Tidak Dapat Terhubung"),
                              _buildSectionContent(
                                  "Pastikan ID dan Password yang dimasukkan benar, serta perangkat dalam mode pairing."),
                              _buildSubSectionTitle("Dukungan Teknis"),
                              _buildSectionContent(
                                "Jika mengalami masalah, hubungi layanan pelanggan melalui fitur dukungan teknis dalam aplikasi.",
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  "Selamat menggunakan Power SmartIQ untuk manajemen kelistrikan yang lebih cerdas dan efisien!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: const CustomFloatingNavbar(selectedIndex: 1),
          ),
        ],
      ),

      // Navbar Mengambang
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF085085)),
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 3),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF085085)),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        content,
        style: TextStyle(fontSize: 14, color: Color(0xFF085085)),
      ),
    );
  }
}
