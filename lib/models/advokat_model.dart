// lib/models/advokat_model.dart (FIXED - Handle Null Values)

import 'dart:convert';

class Advokat {
  final String id;
  final String nama;
  final String foto;
  final String wilayahPraktik;
  final String kota;
  final String deskripsi;
  final int pengalaman;
  final List<String> bidangKeahlian;
  final Statistik statistik;
  final RiwayatPerkara riwayat;

  Advokat({
    required this.id,
    required this.nama,
    required this.foto,
    required this.wilayahPraktik,
    required this.kota,
    required this.deskripsi,
    required this.pengalaman,
    required this.bidangKeahlian,
    required this.statistik,
    required this.riwayat,
  });

  factory Advokat.fromJson(Map<String, dynamic> json) {
    try {
      print('🔄 Parsing advokat: ${json['nama']}'); // DEBUG

      return Advokat(
        id: json['id']?.toString() ?? '',
        nama: json['nama']?.toString() ?? 'Tidak ada nama',
        foto: json['foto']?.toString() ?? '',
        wilayahPraktik: json['wilayahPraktik']?.toString() ??
            json['wilayah_praktik']?.toString() ??
            'Tidak ada wilayah',
        kota: json['kota']?.toString() ?? 'Tidak ada kota',
        deskripsi: json['deskripsi']?.toString() ?? '',
        pengalaman: _parseInt(json['pengalaman']) ?? 0,
        bidangKeahlian:
            _parseStringList(json['bidangKeahlian'] ?? json['bidang_keahlian']),
        statistik: json['statistik'] != null
            ? Statistik.fromJson(json['statistik'])
            : Statistik.empty(),
        riwayat: json['riwayat'] != null
            ? RiwayatPerkara.fromJson(json['riwayat'])
            : RiwayatPerkara.empty(),
      );
    } catch (e, stackTrace) {
      print('❌ Error in Advokat.fromJson: $e');
      print('   JSON: $json');
      print('   Stack: $stackTrace');
      rethrow;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (value is String) {
      try {
        // Jika dari database PostgreSQL array format: {item1,item2}
        if (value.startsWith('{') && value.endsWith('}')) {
          return value
              .substring(1, value.length - 1)
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }
        // Jika JSON string array
        if (value.startsWith('[') && value.endsWith(']')) {
          final List<dynamic> parsed = json.decode(value);
          return parsed
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (e) {
        print('⚠️ Error parsing string list: $e, value: $value');
      }
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'foto': foto,
      'wilayah_praktik': wilayahPraktik,
      'kota': kota,
      'deskripsi': deskripsi,
      'pengalaman': pengalaman,
      'bidang_keahlian': bidangKeahlian,
      'statistik': statistik.toJson(),
      'riwayat': riwayat.toJson(),
    };
  }
}

class Statistik {
  final int jumlahKasus;
  final int kasusSelesai;
  final int kasusMenunggu;
  final int kasusMenang;
  final int kasusKalah;
  final double winRate;
  final List<DataBulanan> dataBulanan;

  Statistik({
    required this.jumlahKasus,
    required this.kasusSelesai,
    required this.kasusMenunggu,
    required this.kasusMenang,
    required this.kasusKalah,
    required this.winRate,
    required this.dataBulanan,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    try {
      return Statistik(
        jumlahKasus:
            _parseInt(json['jumlahKasus'] ?? json['jumlah_kasus']) ?? 0,
        kasusSelesai:
            _parseInt(json['kasusSelesai'] ?? json['kasus_selesai']) ?? 0,
        kasusMenunggu:
            _parseInt(json['kasusMenunggu'] ?? json['kasus_menunggu']) ?? 0,
        kasusMenang:
            _parseInt(json['kasusMenang'] ?? json['kasus_menang']) ?? 0,
        kasusKalah: _parseInt(json['kasusKalah'] ?? json['kasus_kalah']) ?? 0,
        winRate: _parseDouble(json['winRate'] ?? json['win_rate']) ?? 0.0,
        dataBulanan:
            _parseDataBulanan(json['dataBulanan'] ?? json['data_bulanan']),
      );
    } catch (e) {
      print('❌ Error in Statistik.fromJson: $e');
      print('   JSON: $json');
      rethrow;
    }
  }

  factory Statistik.empty() {
    return Statistik(
      jumlahKasus: 0,
      kasusSelesai: 0,
      kasusMenunggu: 0,
      kasusMenang: 0,
      kasusKalah: 0,
      winRate: 0.0,
      dataBulanan: [],
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<DataBulanan> _parseDataBulanan(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map(
              (e) => e is Map<String, dynamic> ? DataBulanan.fromJson(e) : null)
          .where((e) => e != null)
          .cast<DataBulanan>()
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'jumlah_kasus': jumlahKasus,
      'kasus_selesai': kasusSelesai,
      'kasus_menunggu': kasusMenunggu,
      'kasus_menang': kasusMenang,
      'kasus_kalah': kasusKalah,
      'win_rate': winRate,
      'data_bulanan': dataBulanan.map((e) => e.toJson()).toList(),
    };
  }
}

class DataBulanan {
  final String bulan;
  final int jumlahKasus;
  final int kasusSelesai;

  DataBulanan({
    required this.bulan,
    required this.jumlahKasus,
    required this.kasusSelesai,
  });

  factory DataBulanan.fromJson(Map<String, dynamic> json) {
    return DataBulanan(
      bulan: json['bulan']?.toString() ?? '',
      jumlahKasus: _parseInt(json['jumlah_kasus'] ?? json['jumlahKasus']) ?? 0,
      kasusSelesai:
          _parseInt(json['kasus_selesai'] ?? json['kasusSelesai']) ?? 0,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'bulan': bulan,
      'jumlah_kasus': jumlahKasus,
      'kasus_selesai': kasusSelesai,
    };
  }
}

class RiwayatPerkara {
  final List<Perkara> perkaraSelesai;
  final List<Perkara> perkaraBerjalan;

  RiwayatPerkara({
    required this.perkaraSelesai,
    required this.perkaraBerjalan,
  });

  factory RiwayatPerkara.fromJson(Map<String, dynamic> json) {
    try {
      return RiwayatPerkara(
        perkaraSelesai: _parsePerkaraList(
            json['perkaraSelesai'] ?? json['perkara_selesai']),
        perkaraBerjalan: _parsePerkaraList(
            json['perkaraBerjalan'] ?? json['perkara_berjalan']),
      );
    } catch (e) {
      print('❌ Error in RiwayatPerkara.fromJson: $e');
      return RiwayatPerkara.empty();
    }
  }

  factory RiwayatPerkara.empty() {
    return RiwayatPerkara(
      perkaraSelesai: [],
      perkaraBerjalan: [],
    );
  }

  static List<Perkara> _parsePerkaraList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) => e is Map<String, dynamic> ? Perkara.fromJson(e) : null)
          .where((e) => e != null)
          .cast<Perkara>()
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'perkara_selesai': perkaraSelesai.map((e) => e.toJson()).toList(),
      'perkara_berjalan': perkaraBerjalan.map((e) => e.toJson()).toList(),
    };
  }
}

class Perkara {
  final String nomorPerkara;
  final String judulPerkara;
  final String jenisHukum;
  final String tahun;
  final String status;
  final String deskripsi;

  Perkara({
    required this.nomorPerkara,
    required this.judulPerkara,
    required this.jenisHukum,
    required this.tahun,
    required this.status,
    required this.deskripsi,
  });

  factory Perkara.fromJson(Map<String, dynamic> json) {
    return Perkara(
      nomorPerkara: json['nomor_perkara']?.toString() ??
          json['nomorPerkara']?.toString() ??
          '',
      judulPerkara: json['judul_perkara']?.toString() ??
          json['judulPerkara']?.toString() ??
          '',
      jenisHukum: json['jenis_hukum']?.toString() ??
          json['jenisHukum']?.toString() ??
          '',
      tahun: json['tahun']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor_perkara': nomorPerkara,
      'judul_perkara': judulPerkara,
      'jenis_hukum': jenisHukum,
      'tahun': tahun,
      'status': status,
      'deskripsi': deskripsi,
    };
  }
}
