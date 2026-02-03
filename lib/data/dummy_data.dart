import '../models/advokat_model.dart';

class DummyData {
  static List<Advokat> getAdvokatList() {
    return [
      Advokat(
        id: '1',
        nama: 'Dr. Ahmad Santoso, S.H., M.H.',
        foto: 'https://i.pravatar.cc/300?img=12',
        wilayahPraktik: 'Jakarta Pusat',
        kota: 'Jakarta',
        deskripsi:
        'Advokat senior dengan spesialisasi di bidang hukum pidana dan perdata. Memiliki track record kemenangan yang tinggi dalam menangani kasus-kasus kompleks.',
        pengalaman: 15,
        bidangKeahlian: ['Hukum Pidana', 'Hukum Perdata', 'Hukum Bisnis'],
        statistik: Statistik(
          jumlahKasus: 150,
          kasusSelesai: 135,
          kasusMenunggu: 15,
          kasusMenang: 120,
          kasusKalah: 15,
          winRate: 88.9,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 12, kasusSelesai: 10),
            DataBulanan(bulan: 'Feb', jumlahKasus: 15, kasusSelesai: 13),
            DataBulanan(bulan: 'Mar', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Apr', jumlahKasus: 18, kasusSelesai: 16),
            DataBulanan(bulan: 'Mei', jumlahKasus: 14, kasusSelesai: 12),
            DataBulanan(bulan: 'Jun', jumlahKasus: 16, kasusSelesai: 14),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '123/Pid.B/2023/PN.Jkt.Pst',
              judulPerkara: 'Kasus Korupsi PT XYZ',
              jenisHukum: 'Pidana',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Berhasil membebaskan klien dari tuduhan korupsi',
            ),
            Perkara(
              nomorPerkara: '456/Pdt.G/2023/PN.Jkt.Pst',
              judulPerkara: 'Sengketa Tanah Warisan',
              jenisHukum: 'Perdata',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Memenangkan gugatan sengketa tanah warisan',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '789/Pid.Sus/2024/PN.Jkt.Pst',
              judulPerkara: 'Kasus Narkotika',
              jenisHukum: 'Pidana',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Sedang dalam proses persidangan',
            ),
          ],
        ),
      ),
      Advokat(
        id: '2',
        nama: 'Siti Nurhaliza, S.H., M.Kn.',
        foto: 'https://i.pravatar.cc/300?img=5',
        wilayahPraktik: 'Surabaya',
        kota: 'Surabaya',
        deskripsi:
        'Spesialis hukum keluarga dan waris dengan pengalaman menangani berbagai kasus perceraian dan pembagian warisan.',
        pengalaman: 10,
        bidangKeahlian: ['Hukum Keluarga', 'Hukum Waris', 'Mediasi'],
        statistik: Statistik(
          jumlahKasus: 95,
          kasusSelesai: 88,
          kasusMenunggu: 7,
          kasusMenang: 75,
          kasusKalah: 13,
          winRate: 85.2,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 8, kasusSelesai: 7),
            DataBulanan(bulan: 'Feb', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Mar', jumlahKasus: 12, kasusSelesai: 11),
            DataBulanan(bulan: 'Apr', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Mei', jumlahKasus: 11, kasusSelesai: 10),
            DataBulanan(bulan: 'Jun', jumlahKasus: 10, kasusSelesai: 9),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '234/Pdt.G/2023/PN.Sby',
              judulPerkara: 'Perceraian dan Hak Asuh Anak',
              jenisHukum: 'Perdata',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Berhasil mendapatkan hak asuh anak untuk klien',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '567/Pdt.G/2024/PN.Sby',
              judulPerkara: 'Pembagian Harta Warisan',
              jenisHukum: 'Perdata',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Mediasi pembagian harta warisan keluarga',
            ),
          ],
        ),
      ),
      Advokat(
        id: '3',
        nama: 'Budi Hartono, S.H., LL.M.',
        foto: 'https://i.pravatar.cc/300?img=33',
        wilayahPraktik: 'Bandung',
        kota: 'Bandung',
        deskripsi:
        'Expert dalam hukum bisnis dan korporat, telah menangani berbagai transaksi merger dan akuisisi perusahaan besar.',
        pengalaman: 12,
        bidangKeahlian: ['Hukum Bisnis', 'Hukum Korporat', 'M&A'],
        statistik: Statistik(
          jumlahKasus: 120,
          kasusSelesai: 110,
          kasusMenunggu: 10,
          kasusMenang: 98,
          kasusKalah: 12,
          winRate: 89.1,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Feb', jumlahKasus: 12, kasusSelesai: 11),
            DataBulanan(bulan: 'Mar', jumlahKasus: 15, kasusSelesai: 14),
            DataBulanan(bulan: 'Apr', jumlahKasus: 11, kasusSelesai: 10),
            DataBulanan(bulan: 'Mei', jumlahKasus: 13, kasusSelesai: 12),
            DataBulanan(bulan: 'Jun', jumlahKasus: 14, kasusSelesai: 13),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '890/Pdt.G/2023/PN.Bdg',
              judulPerkara: 'Merger Perusahaan ABC',
              jenisHukum: 'Korporat',
              tahun: '2023',
              status: 'Selesai',
              deskripsi: 'Sukses memfasilitasi merger dua perusahaan',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '234/Pdt.G/2024/PN.Bdg',
              judulPerkara: 'Sengketa Kontrak Bisnis',
              jenisHukum: 'Bisnis',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Penyelesaian sengketa kontrak antar perusahaan',
            ),
          ],
        ),
      ),
      Advokat(
        id: '4',
        nama: 'Rina Susanti, S.H.',
        foto: 'https://i.pravatar.cc/300?img=9',
        wilayahPraktik: 'Yogyakarta',
        kota: 'Yogyakarta',
        deskripsi:
        'Advokat muda yang fokus pada hukum HAM dan lingkungan. Aktif dalam berbagai kasus kepentingan publik.',
        pengalaman: 7,
        bidangKeahlian: ['Hukum HAM', 'Hukum Lingkungan', 'Public Interest'],
        statistik: Statistik(
          jumlahKasus: 65,
          kasusSelesai: 58,
          kasusMenunggu: 7,
          kasusMenang: 48,
          kasusKalah: 10,
          winRate: 82.8,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 6, kasusSelesai: 5),
            DataBulanan(bulan: 'Feb', jumlahKasus: 8, kasusSelesai: 7),
            DataBulanan(bulan: 'Mar', jumlahKasus: 7, kasusSelesai: 6),
            DataBulanan(bulan: 'Apr', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Mei', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Jun', jumlahKasus: 8, kasusSelesai: 7),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '345/Pdt.G/2023/PN.Yk',
              judulPerkara: 'Gugatan Pencemaran Lingkungan',
              jenisHukum: 'Lingkungan',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Memenangkan gugatan pencemaran sungai',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '678/Pid.B/2024/PN.Yk',
              judulPerkara: 'Kasus Pelanggaran HAM',
              jenisHukum: 'HAM',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Pembelaan korban pelanggaran HAM',
            ),
          ],
        ),
      ),
      Advokat(
        id: '5',
        nama: 'Andi Wijaya, S.H., M.Hum.',
        foto: 'https://i.pravatar.cc/300?img=15',
        wilayahPraktik: 'Medan',
        kota: 'Medan',
        deskripsi:
        'Advokat berpengalaman di bidang hukum perbankan dan investasi. Sering menangani kasus sengketa kontrak dan aset finansial.',
        pengalaman: 11,
        bidangKeahlian: ['Hukum Bisnis', 'Perbankan', 'Investasi'],
        statistik: Statistik(
          jumlahKasus: 130,
          kasusSelesai: 120,
          kasusMenunggu: 10,
          kasusMenang: 102,
          kasusKalah: 18,
          winRate: 85.0,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 12, kasusSelesai: 11),
            DataBulanan(bulan: 'Feb', jumlahKasus: 13, kasusSelesai: 12),
            DataBulanan(bulan: 'Mar', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Apr', jumlahKasus: 11, kasusSelesai: 10),
            DataBulanan(bulan: 'Mei', jumlahKasus: 14, kasusSelesai: 13),
            DataBulanan(bulan: 'Jun', jumlahKasus: 15, kasusSelesai: 14),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '999/Pdt.G/2023/PN.Mdn',
              judulPerkara: 'Sengketa Investasi Properti',
              jenisHukum: 'Bisnis',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Berhasil menyelesaikan sengketa properti bernilai besar',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '1000/Pdt.G/2024/PN.Mdn',
              judulPerkara: 'Kontrak Pembiayaan Bank',
              jenisHukum: 'Perbankan',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Mendampingi klien korporasi dalam sengketa kontrak bank',
            ),
          ],
        ),
      ),

      Advokat(
        id: '6',
        nama: 'Lisa Permata, S.H., M.Kn.',
        foto: 'https://i.pravatar.cc/300?img=25',
        wilayahPraktik: 'Denpasar',
        kota: 'Denpasar',
        deskripsi:
        'Konsultan hukum bisnis pariwisata dan properti. Aktif mendampingi investor asing dalam perizinan usaha di Bali.',
        pengalaman: 9,
        bidangKeahlian: ['Hukum Bisnis', 'Hukum Properti', 'Hukum Internasional'],
        statistik: Statistik(
          jumlahKasus: 85,
          kasusSelesai: 80,
          kasusMenunggu: 5,
          kasusMenang: 70,
          kasusKalah: 10,
          winRate: 87.5,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 7, kasusSelesai: 6),
            DataBulanan(bulan: 'Feb', jumlahKasus: 8, kasusSelesai: 7),
            DataBulanan(bulan: 'Mar', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Apr', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Mei', jumlahKasus: 8, kasusSelesai: 7),
            DataBulanan(bulan: 'Jun', jumlahKasus: 9, kasusSelesai: 8),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '456/Pdt.G/2023/PN.Dps',
              judulPerkara: 'Sengketa Properti Vila',
              jenisHukum: 'Properti',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Memenangkan perkara sengketa kepemilikan vila di Bali',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '789/Pdt.G/2024/PN.Dps',
              judulPerkara: 'Perjanjian Investasi Asing',
              jenisHukum: 'Internasional',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Pendampingan legal investor asing untuk perizinan usaha',
            ),
          ],
        ),
      ),

      Advokat(
        id: '7',
        nama: 'Rizal Maulana, S.H., M.H.',
        foto: 'https://i.pravatar.cc/300?img=17',
        wilayahPraktik: 'Semarang',
        kota: 'Semarang',
        deskripsi:
        'Ahli dalam hukum ketenagakerjaan dan perburuhan. Telah membantu banyak perusahaan menyelesaikan sengketa hubungan kerja.',
        pengalaman: 13,
        bidangKeahlian: ['Hukum Ketenagakerjaan', 'Mediasi', 'Hukum Perdata'],
        statistik: Statistik(
          jumlahKasus: 105,
          kasusSelesai: 97,
          kasusMenunggu: 8,
          kasusMenang: 86,
          kasusKalah: 11,
          winRate: 88.5,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Feb', jumlahKasus: 10, kasusSelesai: 9),
            DataBulanan(bulan: 'Mar', jumlahKasus: 12, kasusSelesai: 11),
            DataBulanan(bulan: 'Apr', jumlahKasus: 11, kasusSelesai: 10),
            DataBulanan(bulan: 'Mei', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Jun', jumlahKasus: 10, kasusSelesai: 9),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '333/Pdt.G/2023/PN.Smg',
              judulPerkara: 'Pemutusan Hubungan Kerja Sepihak',
              jenisHukum: 'Ketenagakerjaan',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Memenangkan kasus PHK sepihak untuk buruh pabrik tekstil',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '444/Pdt.G/2024/PN.Smg',
              judulPerkara: 'Sengketa Upah dan Tunjangan',
              jenisHukum: 'Perdata',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Mediasi sengketa gaji antara karyawan dan perusahaan',
            ),
          ],
        ),
      ),

      Advokat(
        id: '8',
        nama: 'Dewi Anggraini, S.H., M.Si.',
        foto: 'https://i.pravatar.cc/300?img=22',
        wilayahPraktik: 'Makassar',
        kota: 'Makassar',
        deskripsi:
        'Advokat muda dengan fokus pada hukum perdagangan dan perlindungan konsumen. Aktif dalam penyuluhan hukum di masyarakat.',
        pengalaman: 6,
        bidangKeahlian: ['Hukum Dagang', 'Perlindungan Konsumen', 'Penyuluhan Hukum'],
        statistik: Statistik(
          jumlahKasus: 70,
          kasusSelesai: 62,
          kasusMenunggu: 8,
          kasusMenang: 54,
          kasusKalah: 8,
          winRate: 87.1,
          dataBulanan: [
            DataBulanan(bulan: 'Jan', jumlahKasus: 6, kasusSelesai: 5),
            DataBulanan(bulan: 'Feb', jumlahKasus: 7, kasusSelesai: 6),
            DataBulanan(bulan: 'Mar', jumlahKasus: 8, kasusSelesai: 7),
            DataBulanan(bulan: 'Apr', jumlahKasus: 9, kasusSelesai: 8),
            DataBulanan(bulan: 'Mei', jumlahKasus: 7, kasusSelesai: 6),
            DataBulanan(bulan: 'Jun', jumlahKasus: 8, kasusSelesai: 7),
          ],
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: [
            Perkara(
              nomorPerkara: '111/Pdt.G/2023/PN.Mks',
              judulPerkara: 'Kasus Penipuan E-commerce',
              jenisHukum: 'Perlindungan Konsumen',
              tahun: '2023',
              status: 'Menang',
              deskripsi: 'Berhasil menuntut penjual online yang melakukan penipuan',
            ),
          ],
          perkaraBerjalan: [
            Perkara(
              nomorPerkara: '222/Pdt.G/2024/PN.Mks',
              judulPerkara: 'Sengketa Perdagangan Barang Impor',
              jenisHukum: 'Dagang',
              tahun: '2024',
              status: 'Berjalan',
              deskripsi: 'Pendampingan hukum dalam sengketa impor barang',
            ),
          ],
        ),
      ),

    ];
  }

  static List<String> getKotaList() {
    return ['Semua Kota', 'Jakarta', 'Surabaya', 'Bandung', 'Yogyakarta', 'Medan', 'Denpasar', 'Semarang'];
  }

  static List<String> getBidangHukumList() {
    return [
      'Semua Bidang',
      'Hukum Pidana',
      'Hukum Perdata',
      'Hukum Bisnis',
      'Hukum Keluarga',
      'Hukum Waris',
      'Hukum Korporat',
      'Hukum HAM',
      'Hukum Lingkungan',
    ];
  }
}

