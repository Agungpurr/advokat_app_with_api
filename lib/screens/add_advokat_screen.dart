// lib/screens/add_advokat_screen.dart (FIXED - Save to API)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/advokat_model.dart';
import '../services/advokat_service.dart';

class AddAdvokatScreen extends StatefulWidget {
  final VoidCallback onAdvokatAdded;

  const AddAdvokatScreen({Key? key, required this.onAdvokatAdded})
      : super(key: key);

  @override
  State<AddAdvokatScreen> createState() => _AddAdvokatScreenState();
}

class _AddAdvokatScreenState extends State<AddAdvokatScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final AdvokatService _advokatService = AdvokatService();

  // Controllers
  final _namaController = TextEditingController();
  final _fotoController = TextEditingController();
  final _wilayahController = TextEditingController();
  final _kotaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _pengalamanController = TextEditingController();
  final _jumlahKasusController = TextEditingController();
  final _kasusSelesaiController = TextEditingController();
  final _kasusMenangController = TextEditingController();
  final _kasusKalahController = TextEditingController();

  File? _selectedImage;
  String _photoSource = 'url';
  bool _isSubmitting = false;

  final List<String> _selectedBidangKeahlian = [];
  final List<String> _availableBidang = [
    'Hukum Pidana',
    'Hukum Perdata',
    'Hukum Bisnis',
    'Hukum Keluarga',
    'Hukum Waris',
    'Hukum Korporat',
    'Hukum HAM',
    'Hukum Lingkungan',
  ];

  final List<DataBulanan> _dataBulanan = [];
  final List<Perkara> _perkaraSelesai = [];
  final List<Perkara> _perkaraBerjalan = [];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _photoSource = 'upload';
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih gambar: $e', isError: true);
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('URL (Link)'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _photoSource = 'url';
                  _selectedImage = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDataBulananDialog() {
    final bulanController = TextEditingController();
    final jumlahKasusController = TextEditingController();
    final kasusSelesaiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Data Bulanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bulanController,
                decoration: const InputDecoration(
                  labelText: 'Bulan',
                  hintText: 'Contoh: Jan, Feb, Mar',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: jumlahKasusController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Kasus',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kasusSelesaiController,
                decoration: const InputDecoration(
                  labelText: 'Kasus Selesai',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (bulanController.text.isNotEmpty &&
                  jumlahKasusController.text.isNotEmpty &&
                  kasusSelesaiController.text.isNotEmpty) {
                setState(() {
                  _dataBulanan.add(DataBulanan(
                    bulan: bulanController.text,
                    jumlahKasus: int.parse(jumlahKasusController.text),
                    kasusSelesai: int.parse(kasusSelesaiController.text),
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showAddPerkaraDialog(bool isSelesai) {
    final nomorPerkaraController = TextEditingController();
    final judulPerkaraController = TextEditingController();
    final jenisHukumController = TextEditingController();
    final tahunController = TextEditingController();
    final statusController = TextEditingController();
    final deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Perkara ${isSelesai ? "Selesai" : "Berjalan"}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomorPerkaraController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Perkara',
                  hintText: '2024/Pdt.G/123/PN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: judulPerkaraController,
                decoration: const InputDecoration(
                  labelText: 'Judul Perkara',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: jenisHukumController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Hukum',
                  hintText: 'Hukum Pidana',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tahunController,
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  hintText: '2024',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  hintText: isSelesai ? 'Menang/Kalah' : 'Berjalan',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nomorPerkaraController.text.isNotEmpty &&
                  judulPerkaraController.text.isNotEmpty) {
                final perkara = Perkara(
                  nomorPerkara: nomorPerkaraController.text,
                  judulPerkara: judulPerkaraController.text,
                  jenisHukum: jenisHukumController.text,
                  tahun: tahunController.text,
                  status: statusController.text,
                  deskripsi: deskripsiController.text,
                );

                setState(() {
                  if (isSelesai) {
                    _perkaraSelesai.add(perkara);
                  } else {
                    _perkaraBerjalan.add(perkara);
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedBidangKeahlian.isEmpty) {
      _showSnackBar('Pilih minimal 1 bidang keahlian', isError: true);
      return;
    }

    if (_selectedImage == null && _fotoController.text.isEmpty) {
      _showSnackBar('Pilih foto atau masukkan URL foto', isError: true);
      return;
    }

    final jumlahKasus = int.parse(_jumlahKasusController.text);
    final kasusSelesai = int.parse(_kasusSelesaiController.text);
    final kasusMenang = int.parse(_kasusMenangController.text);
    final kasusKalah = int.parse(_kasusKalahController.text);

    if (kasusSelesai > jumlahKasus) {
      _showSnackBar('Kasus selesai tidak boleh lebih besar dari total kasus',
          isError: true);
      return;
    }

    if (kasusMenang + kasusKalah > kasusSelesai) {
      _showSnackBar(
          'Total kasus menang + kalah tidak boleh lebih dari kasus selesai',
          isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final winRate =
          kasusSelesai > 0 ? (kasusMenang / kasusSelesai) * 100 : 0.0;
      final kasusMenunggu = jumlahKasus - kasusSelesai;

      // Default data bulanan jika kosong
      final dataBulanan = _dataBulanan.isNotEmpty
          ? _dataBulanan
          : [
              DataBulanan(bulan: 'Jan', jumlahKasus: 0, kasusSelesai: 0),
              DataBulanan(bulan: 'Feb', jumlahKasus: 0, kasusSelesai: 0),
              DataBulanan(bulan: 'Mar', jumlahKasus: 0, kasusSelesai: 0),
              DataBulanan(bulan: 'Apr', jumlahKasus: 0, kasusSelesai: 0),
              DataBulanan(bulan: 'Mei', jumlahKasus: 0, kasusSelesai: 0),
              DataBulanan(bulan: 'Jun', jumlahKasus: 0, kasusSelesai: 0),
            ];

      final statistik = Statistik(
        jumlahKasus: jumlahKasus,
        kasusSelesai: kasusSelesai,
        kasusMenunggu: kasusMenunggu,
        kasusMenang: kasusMenang,
        kasusKalah: kasusKalah,
        winRate: winRate,
        dataBulanan: dataBulanan,
      );

      final riwayat = RiwayatPerkara(
        perkaraSelesai: _perkaraSelesai,
        perkaraBerjalan: _perkaraBerjalan,
      );

      // Prioritas: URL > fallback avatar
      String fotoUrl = _fotoController.text.isNotEmpty
          ? _fotoController.text
          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_namaController.text)}&size=200';

      final newAdvokat = Advokat(
        id: '', // Backend akan generate ID
        nama: _namaController.text,
        foto: fotoUrl,
        wilayahPraktik: _wilayahController.text,
        kota: _kotaController.text,
        deskripsi: _deskripsiController.text,
        pengalaman: int.parse(_pengalamanController.text),
        bidangKeahlian: _selectedBidangKeahlian,
        statistik: statistik,
        riwayat: riwayat,
      );

      print('📤 Submitting advokat to API: ${newAdvokat.nama}');

      // 🔥 KIRIM KE API BACKEND
      await _advokatService.createAdvokat(newAdvokat);

      print('✅ Advokat successfully created in database');

      if (!mounted) return;

      _showSnackBar(
        '${newAdvokat.nama} berhasil ditambahkan dengan Win Rate ${winRate.toStringAsFixed(1)}%',
        isError: false,
      );

      // Refresh list di HomeScreen
      widget.onAdvokatAdded();

      // Tutup screen
      Navigator.pop(context, true);
    } catch (e) {
      print('❌ Error creating advokat: $e');
      _showSnackBar('Gagal menambahkan advokat: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Advokat Baru'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle('Informasi Dasar', Icons.person),
                _buildTextField(
                  controller: _namaController,
                  label: 'Nama Lengkap',
                  hint: 'Contoh: Dr. Ahmad Santoso, S.H., M.H.',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPhotoSection(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _wilayahController,
                  label: 'Wilayah Praktik',
                  hint: 'Contoh: Jakarta Pusat',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wilayah praktik tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _kotaController,
                  label: 'Kota',
                  hint: 'Contoh: Jakarta',
                  icon: Icons.location_city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kota tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _pengalamanController,
                  label: 'Pengalaman (Tahun)',
                  hint: '15',
                  icon: Icons.work,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pengalaman tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Harus berupa angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _deskripsiController,
                  label: 'Deskripsi Singkat',
                  hint: 'Jelaskan keahlian dan pengalaman...',
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Bidang Keahlian', Icons.school),
                _buildBidangKeahlianSelector(),
                const SizedBox(height: 24),
                _buildSectionTitle('Data Kinerja & Statistik', Icons.bar_chart),
                const Text(
                  'Masukkan data kinerja advokat untuk tracking performa',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _jumlahKasusController,
                        label: 'Total Kasus',
                        hint: '150',
                        icon: Icons.gavel,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Harus angka';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _kasusSelesaiController,
                        label: 'Kasus Selesai',
                        hint: '135',
                        icon: Icons.check_circle,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Harus angka';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _kasusMenangController,
                        label: 'Kasus Menang',
                        hint: '120',
                        icon: Icons.emoji_events,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Harus angka';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _kasusKalahController,
                        label: 'Kasus Kalah',
                        hint: '15',
                        icon: Icons.close,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Harus angka';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Data Kasus Bulanan', Icons.show_chart),
                _buildDataBulananList(),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _showAddDataBulananDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Data Bulan'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Riwayat Perkara', Icons.history),
                _buildPerkaraList('Perkara Selesai', _perkaraSelesai, true),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showAddPerkaraDialog(true),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Perkara Selesai'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPerkaraList('Perkara Berjalan', _perkaraBerjalan, false),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showAddPerkaraDialog(false),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Perkara Berjalan'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Data Advokat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF212121)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto Profil',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 16,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              size: 16, color: Colors.white),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() => _selectedImage = null);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(_selectedImage != null ? 'Ganti Foto' : 'Pilih Foto'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'atau',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (_photoSource == 'url')
              _buildTextField(
                controller: _fotoController,
                label: 'URL Foto',
                hint: 'https://example.com/foto.jpg',
                icon: Icons.link,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataBulananList() {
    if (_dataBulanan.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Belum ada data bulanan. Klik tombol di bawah untuk menambah.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _dataBulanan.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final data = _dataBulanan[index];
          return ListTile(
            title: Text(data.bulan),
            subtitle: Text(
                'Kasus: ${data.jumlahKasus}, Selesai: ${data.kasusSelesai}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() => _dataBulanan.removeAt(index));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPerkaraList(
      String title, List<Perkara> perkara, bool isSelesai) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (perkara.isEmpty)
              Text(
                'Belum ada perkara',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            else
              ...perkara.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(p.judulPerkara,
                      style: const TextStyle(fontSize: 14)),
                  subtitle: Text(p.nomorPerkara,
                      style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      setState(() {
                        if (isSelesai) {
                          _perkaraSelesai.removeAt(index);
                        } else {
                          _perkaraBerjalan.removeAt(index);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildBidangKeahlianSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih bidang keahlian (minimal 1):',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableBidang.map((bidang) {
                final isSelected = _selectedBidangKeahlian.contains(bidang);
                return FilterChip(
                  label: Text(bidang),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBidangKeahlian.add(bidang);
                      } else {
                        _selectedBidangKeahlian.remove(bidang);
                      }
                    });
                  },
                  selectedColor: Colors.yellow.shade100,
                  checkmarkColor: Colors.yellow.shade700,
                );
              }).toList(),
            ),
            if (_selectedBidangKeahlian.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Pilih minimal 1 bidang keahlian',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _fotoController.dispose();
    _wilayahController.dispose();
    _kotaController.dispose();
    _deskripsiController.dispose();
    _pengalamanController.dispose();
    _jumlahKasusController.dispose();
    _kasusSelesaiController.dispose();
    _kasusMenangController.dispose();
    _kasusKalahController.dispose();
    super.dispose();
  }
}
