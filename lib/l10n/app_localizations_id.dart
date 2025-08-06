// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get accountInformation => 'Informasi Akun';

  @override
  String get systemInformation => 'Informasi Sistem';

  @override
  String get userId => 'ID Pengguna';

  @override
  String get role => 'Peran';

  @override
  String get status => 'Status';

  @override
  String get phone => 'Telepon';

  @override
  String get address => 'Alamat';

  @override
  String get verifiedEmail => 'Email Terverifikasi';

  @override
  String get already => 'Sudah';

  @override
  String get notYet => 'Belum';

  @override
  String get lastLogin => 'Login Terakhir';

  @override
  String get madeIn => 'Dibuat Pada';

  @override
  String get updatedOn => 'Diperbarui Pada';

  @override
  String get accountSettings => 'Pengaturan Akun';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirmationTitle => 'Konfirmasi Keluar';

  @override
  String get logoutConfirmationMessage =>
      'Apakah Anda yakin ingin keluar dari akun ini?';

  @override
  String get cancel => 'Batal';

  @override
  String get confirmLogout => 'Keluar';

  @override
  String get editProfile => 'Ubah Profil';

  @override
  String get username => 'Nama Pengguna';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Nomor Telepon';

  @override
  String get saveChanges => 'SIMPAN PERUBAHAN';

  @override
  String pleaseEnterField(Object field) {
    return 'Silakan isi $field';
  }

  @override
  String get invalidEmail => 'Email tidak valid';

  @override
  String get loading => 'Memuat...';

  @override
  String get success => 'Berhasil';

  @override
  String get error => 'Kesalahan';

  @override
  String get profile => 'Profil';

  @override
  String get device => 'Perangkat';

  @override
  String get addDevice => 'Tambah Perangkat';

  @override
  String get deviceList => 'Daftar Perangkat';

  @override
  String get security => 'Keamanan';

  @override
  String get changePassword => 'Ubah Kata Sandi';

  @override
  String get forgotPassword => 'Lupa Kata Sandi?';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'Bahasa Inggris';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get completeAccountInfo => 'Lengkapi\ninformasi akun';

  @override
  String get nameLabel => 'Nama';

  @override
  String get phoneLabel => 'No. Hp';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Alamat';

  @override
  String get signUp => 'Daftar';

  @override
  String get unknownError => 'Terjadi kesalahan';

  @override
  String get changePasswordTitle => 'Ubah Kata Sandi';

  @override
  String get currentPasswordLabel => 'Kata Sandi Saat Ini';

  @override
  String get newPasswordLabel => 'Kata Sandi Baru';

  @override
  String get confirmNewPasswordLabel => 'Konfirmasi Kata Sandi Baru';

  @override
  String fieldRequired(Object field) {
    return 'Harap masukkan $field';
  }

  @override
  String get passwordMinLength => 'Password minimal 8 karakter';

  @override
  String get passwordMismatch => 'Password baru dan konfirmasi tidak sama';

  @override
  String get forgotPasswordTitle => 'Lupa Kata Sandi';

  @override
  String get forgotPasswordHeader => 'Lupa kata sandi?';

  @override
  String get forgotPasswordDescription =>
      'Kami akan mengirimkan tautan untuk mengatur ulang kata sandi ke email Anda.';

  @override
  String get send => 'Kirim';

  @override
  String get signInTitle => 'Masuk';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get signInButton => 'Masuk';

  @override
  String get noAccountText => 'Belum punya akun?';

  @override
  String get signUpLink => 'Daftar';

  @override
  String get signUpTitle => 'Daftar';

  @override
  String get confirmPasswordLabel => 'Konfirmasi Kata Sandi';

  @override
  String get nextButton => 'Lanjut';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get signInLink => 'Masuk';

  @override
  String get allFieldsRequired => 'Semua kolom harus diisi';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get smartHomeTitle => 'Rumah Pintar';

  @override
  String get smartHomeSubtitle => 'Kendalikan perangkat pintarmu';

  @override
  String get deviceControl => 'Kontrol Perangkat';

  @override
  String get noControlDeviceTitle => 'Anda belum memiliki perangkat kontrol';

  @override
  String get noControlDeviceSubtitle =>
      'Silakan tambahkan perangkat kontrol terlebih dahulu.';

  @override
  String get quickScenes => 'Skena Cepat';

  @override
  String get allOn => 'Nyalakan Semua';

  @override
  String get allOff => 'Matikan Semua';

  @override
  String get statusOn => 'AKTIF';

  @override
  String get statusOff => 'NONAKTIF';

  @override
  String activeDevices(Object count) {
    return '$count Aktif';
  }

  @override
  String get addDeviceTitle => 'Tambah Perangkat Baru';

  @override
  String get deviceNameLabel => 'Nama Perangkat';

  @override
  String get deviceIdLabel => 'ID Perangkat';

  @override
  String get deviceTypeLabel => 'Tipe Perangkat';

  @override
  String get deviceBuildingLabel => 'Gedung';

  @override
  String get installationDateLabel => 'Tanggal Instalasi';

  @override
  String get selectDateText => 'Pilih Tanggal';

  @override
  String get saveDeviceButton => 'SIMPAN PERANGKAT';

  @override
  String get pleaseSelectDeviceType => 'Pilih tipe perangkat';

  @override
  String get pleaseSelectInstallationDate => 'Harap pilih tanggal instalasi';

  @override
  String get deviceAddedSuccess => 'Perangkat berhasil ditambahkan';

  @override
  String deviceAddError(Object error) {
    return 'Kesalahan: $error';
  }

  @override
  String get deviceListTitle => 'Daftar Perangkat';

  @override
  String get noDevices => 'Tidak ada perangkat';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Hapus';

  @override
  String get deviceId => 'ID Perangkat';

  @override
  String get deviceType => 'Tipe';

  @override
  String get deviceBuilding => 'Gedung';

  @override
  String get installationDate => 'Tanggal Instalasi';

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusInactive => 'Nonaktif';

  @override
  String get statusMaintenance => 'Pemeliharaan';

  @override
  String get deleteDeviceTitle => 'Hapus Perangkat';

  @override
  String deleteDeviceConfirm(Object deviceName) {
    return 'Apakah Anda yakin ingin menghapus perangkat $deviceName?';
  }

  @override
  String deleteDeviceSuccess(Object deviceName) {
    return 'Perangkat $deviceName berhasil dihapus';
  }

  @override
  String deleteDeviceError(Object error) {
    return 'Gagal menghapus perangkat: $error';
  }

  @override
  String get confirmDelete => 'Hapus';

  @override
  String get editDeviceTitle => 'Edit Perangkat';

  @override
  String get deviceStatusLabel => 'Status';

  @override
  String get deviceSaveButton => 'SIMPAN PERUBAHAN';

  @override
  String get deviceUpdatedSuccess => 'Perangkat berhasil diperbarui';

  @override
  String deviceUpdateError(Object error) {
    return 'Gagal memperbarui: $error';
  }

  @override
  String get userGuideTitle =>
      'Panduan Penggunaan Aplikasi Smart Power Management';

  @override
  String get introTitle => '1. Pendahuluan';

  @override
  String get introContent =>
      'Smart Power Management adalah aplikasi untuk memantau dan mengendalikan sistem kelistrikan secara efisien. Pastikan Anda memiliki koneksi internet yang stabil untuk performa optimal.';

  @override
  String get installTitle => '2. Instalasi dan Persiapan';

  @override
  String get downloadTitle => 'Unduh dan Instal Aplikasi';

  @override
  String get downloadContent =>
      'Unduh Smart Power Management di Google Play Store atau Apple Store. Pastikan perangkat memiliki ruang penyimpanan yang cukup.';

  @override
  String get internetTitle => 'Koneksi Internet';

  @override
  String get internetContent =>
      'Pastikan perangkat terhubung ke koneksi internet yang stabil agar aplikasi dapat berjalan dengan baik.';

  @override
  String get monitoringTitle => '3. Tambahkan Perangkat Monitoring';

  @override
  String get openMonitoringTitle => 'Buka Menu Monitoring';

  @override
  String get openMonitoringContent =>
      'Pada halaman utama aplikasi, pilih menu Monitoring.';

  @override
  String get addMonitoringDeviceTitle => 'Tambah Perangkat Baru';

  @override
  String get addMonitoringDeviceContent =>
      'Tekan ikon (+), lalu masukkan ID dan password perangkat yang diberikan oleh teknisi.';

  @override
  String get controllingTitle => '4. Hubungkan Perangkat Kontrol';

  @override
  String get openControllingTitle => 'Buka Menu Controlling';

  @override
  String get openControllingContent =>
      'Dari halaman utama, pilih menu Controlling untuk mulai menghubungkan perangkat kontrol.';

  @override
  String get addControllingDeviceContent =>
      'Masukkan informasi perangkat seperti nama, alamat IP, dan kode akses dengan benar.';

  @override
  String get tipsTitle => '5. Tips dan Pemecahan Masalah';

  @override
  String get cannotConnectTitle => 'Perangkat Tidak Dapat Terhubung';

  @override
  String get cannotConnectContent =>
      'Pastikan ID dan Password yang dimasukkan sudah benar, dan perangkat dalam mode pairing.';

  @override
  String get supportTitle => 'Dukungan Teknis';

  @override
  String get supportContent =>
      'Jika mengalami masalah, silakan hubungi layanan pelanggan melalui fitur dukungan teknis dalam aplikasi.';

  @override
  String get closingMessage =>
      'Selamat menggunakan Smart Power Management untuk pengelolaan listrik yang lebih cerdas dan efisien!';

  @override
  String homeWelcomeTitle(Object name) {
    return 'Selamat Datang\n$name!';
  }

  @override
  String get homeIntroText => 'Mari mulai menstabilkan penggunaan daya kita!';

  @override
  String get homeMenuMonitoring => 'Monitoring';

  @override
  String get homeMenuControlling => 'Kontrol';

  @override
  String get homeMenuAccount => 'Akun';

  @override
  String get homeMenuUserGuide => 'Panduan';

  @override
  String get monitorHeaderTitle => 'Pantau penggunaan\nlistrik Anda!';

  @override
  String get monitorHistoryButton => 'Lihat Riwayat Data';

  @override
  String get monitorDeviceUnavailableTitle =>
      'Perangkat monitoring belum tersedia';

  @override
  String get monitorDeviceUnavailableDesc =>
      'Silakan daftarkan perangkat monitoring terlebih dahulu untuk mengakses fitur ini.';

  @override
  String get monitorLiveTitle => 'Data Monitoring Langsung';

  @override
  String get monitorPredictionDropdownLabel => 'Opsi Prediksi:';

  @override
  String get monitorChartVoltageCurrent => 'Tegangan & Arus';

  @override
  String get monitorChartPowerEnergy => 'Daya & Energi';

  @override
  String get monitorChartFreqPf => 'Frekuensi & Faktor Daya';

  @override
  String get monitorChartTempHumidity => 'Suhu & Kelembapan';

  @override
  String monitorDatetimeWIB(Object date, Object time) {
    return '$date : $time WIB';
  }

  @override
  String get monitorMetricVoltage => 'Tegangan';

  @override
  String get monitorMetricCurrent => 'Arus';

  @override
  String get monitorMetricPower => 'Daya';

  @override
  String get monitorMetricEnergy => 'Energi';

  @override
  String get monitorMetricFrequency => 'Frekuensi';

  @override
  String get monitorMetricPowerFactor => 'Faktor Daya';

  @override
  String get monitorMetricTemp => 'Suhu';

  @override
  String get monitorMetricHumidity => 'Kelembapan';

  @override
  String get welcomeGetStarted => 'Mulai Sekarang';

  @override
  String get welcomeSignUp => 'Daftar';

  @override
  String get welcomeSignIn => 'Masuk';

  @override
  String get emailRequired => 'Email wajib diisi.';

  @override
  String get linkSentSuccess => 'Tautan reset berhasil dikirim ke email kamu.';

  @override
  String get linkSentFailed => 'Gagal mengirim tautan reset. Coba lagi nanti.';

  @override
  String get emailVerified => 'Email Terverifikasi';

  @override
  String get verifyEmail => 'Verifikasi Email';

  @override
  String get emailAlreadyVerified => 'Email Anda sudah terverifikasi';

  @override
  String get enterVerificationCodeSentToEmail =>
      'Masukkan kode verifikasi 6 digit yang dikirim ke email Anda.';

  @override
  String get pleaseEnter6DigitCode => 'Silakan masukkan kode 6 digit';

  @override
  String get emailSuccessfullyVerified => 'Email berhasil diverifikasi!';

  @override
  String get verificationFailed => 'Verifikasi gagal';

  @override
  String get verificationCodeResent =>
      'Kode verifikasi telah dikirim ulang ke email Anda.';

  @override
  String get failedToResendCode => 'Gagal mengirim ulang kode';

  @override
  String get verify => 'Verifikasi';

  @override
  String get resendCode => 'Kirim Ulang Kode';

  @override
  String get activeStatus => 'Sedang Aktif';

  @override
  String get inactiveStatus => 'Tidak Aktif';

  @override
  String get predictionDataNotAvailable => 'Data prediksi tidak tersedia';

  @override
  String get energyPrediction => 'Prediksi Energi';

  @override
  String get dailyPrediction => 'Prediksi Harian';

  @override
  String get monthlyPrediction => 'Prediksi Bulanan';

  @override
  String get yearlyPrediction => 'Prediksi Tahunan';

  @override
  String get date => 'Tanggal';

  @override
  String get month => 'Bulan';

  @override
  String get year => 'Tahun';

  @override
  String get averagePowerW => 'Daya Rata2 (W)';

  @override
  String get totalEnergyKwh => 'Energi (kWh)';

  @override
  String get estimatedCost => 'Perkiraan Biaya';

  @override
  String get dailyPredictionTitle => 'Prediksi Harian (7 Hari Terakhir)';

  @override
  String get dateColumn => 'Tanggal';

  @override
  String get energyColumn => 'Energi (kWh)';

  @override
  String get costColumn => 'Biaya';

  @override
  String get currencySymbol => 'Rp';

  @override
  String get defaultValue => '-';

  @override
  String get currencyFormat => 'Rpamount';

  @override
  String get defaultDisplayText => '-';

  @override
  String get decimalFormat => 'value';

  @override
  String get voltage => 'Tegangan';

  @override
  String get current => 'Arus';

  @override
  String get power => 'Daya';

  @override
  String get energy => 'Energi';

  @override
  String get frequency => 'Frekuensi';

  @override
  String get powerFactor => 'Faktor Daya';

  @override
  String get temperature => 'Suhu';

  @override
  String get humidity => 'Kelembapan';

  @override
  String get voltageUnit => 'V';

  @override
  String get currentUnit => 'A';

  @override
  String get powerUnit => 'W';

  @override
  String get energyUnit => 'kWh';

  @override
  String get frequencyUnit => 'Hz';

  @override
  String get powerFactorUnit => 'VA';

  @override
  String get temperatureUnit => '°C';

  @override
  String get humidityUnit => '%';

  @override
  String get energyUsage => 'Penggunaan Energi';

  @override
  String get energyAxisLabel => 'Energi (kWh)';

  @override
  String get energySeriesName => 'Energi';

  @override
  String get avgDaily => 'Rata-rata Harian';

  @override
  String get peakToday => 'Puncak Hari Ini';

  @override
  String get energyToday => 'Energi Hari Ini';

  @override
  String get kilowatt => 'kW';

  @override
  String get kilowattHour => 'kWh';

  @override
  String get energyHistory => 'Riwayat Energi';

  @override
  String get energyConsumption => 'Konsumsi Energi';

  @override
  String get energyConsumptionDescription =>
      'Lihat data historis konsumsi energi';

  @override
  String get energyConsumptionData => 'Data Konsumsi Energi';

  @override
  String get hours => 'Jam';

  @override
  String get selectDateRange => 'Pilih Rentang Tanggal';

  @override
  String get avgEnergy => 'Rata-rata Energi';

  @override
  String get peakPower => 'Daya Puncak';

  @override
  String get totalEnergy => 'Total Energi';

  @override
  String get watt => 'Watt';

  @override
  String get loadingEnergyData => 'Memuat data energi...';

  @override
  String get noEnergyData => 'Tidak Ada Data Energi';

  @override
  String get adjustDateRange =>
      'Coba sesuaikan rentang tanggal atau periksa koneksi Anda';

  @override
  String get hourlyPowerConsumption => 'Konsumsi Daya Per Jam';

  @override
  String get time => 'Waktu';

  @override
  String get dataLoadFailed => 'Gagal memuat data';

  @override
  String get sendFailed => 'Gagal mengirim tautan reset';

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get type => 'Tipe';

  @override
  String get building => 'Gedung';

  @override
  String deleteDeviceMessage(Object deviceName) {
    return 'Are you sure you want to delete $deviceName?';
  }

  @override
  String get confirm => 'Konfirmasi';

  @override
  String deviceDeleted(Object deviceName) {
    return '$deviceName deleted successfully';
  }

  @override
  String deleteFailed(Object error) {
    return 'Failed to delete device: $error';
  }

  @override
  String get refresh => 'Segarkan';

  @override
  String get saveChangesButton => 'Simpan Perubahan';
}
