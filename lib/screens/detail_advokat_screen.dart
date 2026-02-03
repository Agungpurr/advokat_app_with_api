// lib/screens/detail_advokat_screen.dart (WITH UPDATE & DELETE)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/advokat_model.dart';
import '../services/advokat_service.dart';

class DetailAdvokatScreen extends StatefulWidget {
  final Advokat advokat;
  final VoidCallback? onAdvokatChanged;

  const DetailAdvokatScreen({
    Key? key,
    required this.advokat,
    this.onAdvokatChanged,
  }) : super(key: key);

  @override
  State<DetailAdvokatScreen> createState() => _DetailAdvokatScreenState();
}

class _DetailAdvokatScreenState extends State<DetailAdvokatScreen> {
  final AdvokatService _advokatService = AdvokatService();
  late Advokat _currentAdvokat;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _currentAdvokat = widget.advokat;
  }

  Future<void> _refreshAdvokatData() async {
    try {
      final updatedAdvokat =
          await _advokatService.getAdvokatById(_currentAdvokat.id);
      setState(() {
        _currentAdvokat = updatedAdvokat;
      });
    } catch (e) {
      print('Error refreshing advokat data: $e');
    }
  }

  Future<void> _deleteAdvokat() async {
    // Tampilkan confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Advokat'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${_currentAdvokat.nama}?\n\nSemua data termasuk statistik dan riwayat perkara akan dihapus.',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      await _advokatService.deleteAdvokat(_currentAdvokat.id);

      if (!mounted) return;

      // Tampilkan success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_currentAdvokat.nama} berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );

      // Callback untuk refresh list
      widget.onAdvokatChanged?.call();

      // Kembali ke halaman sebelumnya
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isDeleting = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus advokat: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAdvokatScreen(
          advokat: _currentAdvokat,
        ),
      ),
    );

    // Jika ada perubahan, refresh data
    if (result == true) {
      await _refreshAdvokatData();
      widget.onAdvokatChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileSection(),
                    _buildStatisticsSection(),
                    _buildChartSection(),
                    _buildExpertiseSection(),
                    _buildCaseHistorySection(),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
          if (_isDeleting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToEdit,
        backgroundColor: const Color(0xFFFFD700),
        icon: const Icon(Icons.edit, color: Color(0xFF212121)),
        label: const Text(
          'Edit',
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF212121),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: _deleteAdvokat,
          tooltip: 'Hapus Advokat',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF212121),
                    const Color(0xFF212121).withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _currentAdvokat.foto.isNotEmpty
                        ? NetworkImage(_currentAdvokat.foto)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: _currentAdvokat.foto.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentAdvokat.nama,
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil Advokat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on, _currentAdvokat.wilayahPraktik),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.work, '${_currentAdvokat.pengalaman} Tahun Pengalaman'),
          if (_currentAdvokat.deskripsi.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentAdvokat.deskripsi,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Kinerja',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Kasus',
                  '${_currentAdvokat.statistik.jumlahKasus}',
                  Icons.gavel,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Kasus Selesai',
                  '${_currentAdvokat.statistik.kasusSelesai}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Kasus Menang',
                  '${_currentAdvokat.statistik.kasusMenang}',
                  Icons.emoji_events,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Win Rate',
                  '${_currentAdvokat.statistik.winRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    if (_currentAdvokat.statistik.dataBulanan.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Grafik Kasus Bulanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada data kasus bulanan',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final maxValue = _currentAdvokat.statistik.dataBulanan
        .map((e) => e.jumlahKasus)
        .fold<int>(0, (max, value) => value > max ? value : max);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Kasus Bulanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxValue + 5).toDouble(),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 &&
                            index <
                                _currentAdvokat.statistik.dataBulanan.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _currentAdvokat
                                  .statistik.dataBulanan[index].bulan,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: _currentAdvokat.statistik.dataBulanan
                    .asMap()
                    .entries
                    .map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.jumlahKasus.toDouble(),
                        color: Colors.blue.shade400,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: entry.value.kasusSelesai.toDouble(),
                        color: Colors.green.shade400,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(Colors.blue.shade400, 'Jumlah Kasus'),
              const SizedBox(width: 16),
              _buildLegend(Colors.green.shade400, 'Kasus Selesai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildExpertiseSection() {
    if (_currentAdvokat.bidangKeahlian.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bidang Keahlian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currentAdvokat.bidangKeahlian.map((bidang) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  bidang,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseHistorySection() {
    final hasSelesai = _currentAdvokat.riwayat.perkaraSelesai.isNotEmpty;
    final hasBerjalan = _currentAdvokat.riwayat.perkaraBerjalan.isNotEmpty;

    if (!hasSelesai && !hasBerjalan) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Column(
          children: [
            Text(
              'Riwayat Perkara',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Icon(Icons.folder_open, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Belum ada riwayat perkara',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Perkara',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (hasSelesai) ...[
            _buildCaseList(
                'Perkara Selesai', _currentAdvokat.riwayat.perkaraSelesai),
            if (hasBerjalan) const SizedBox(height: 16),
          ],
          if (hasBerjalan)
            _buildCaseList(
                'Perkara Berjalan', _currentAdvokat.riwayat.perkaraBerjalan),
        ],
      ),
    );
  }

  Widget _buildCaseList(String title, List<Perkara> cases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...cases.map((perkara) => _buildCaseCard(perkara)),
      ],
    );
  }

  Widget _buildCaseCard(Perkara perkara) {
    Color statusColor;
    switch (perkara.status.toLowerCase()) {
      case 'menang':
        statusColor = Colors.green;
        break;
      case 'kalah':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  perkara.judulPerkara,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  perkara.status,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            perkara.nomorPerkara,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  perkara.jenisHukum,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                perkara.tahun,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (perkara.deskripsi.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              perkara.deskripsi,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================
// EDIT ADVOKAT SCREEN (Simplified Version)
// ============================================

// lib/screens/detail_advokat_screen.dart - EditAdvokatScreen EXTENDED

class EditAdvokatScreen extends StatefulWidget {
  final Advokat advokat;

  const EditAdvokatScreen({Key? key, required this.advokat}) : super(key: key);

  @override
  State<EditAdvokatScreen> createState() => _EditAdvokatScreenState();
}

class _EditAdvokatScreenState extends State<EditAdvokatScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdvokatService _advokatService = AdvokatService();

  late TextEditingController _namaController;
  late TextEditingController _fotoController;
  late TextEditingController _wilayahController;
  late TextEditingController _kotaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _pengalamanController;
  late TextEditingController _jumlahKasusController;
  late TextEditingController _kasusSelesaiController;
  late TextEditingController _kasusMenangController;
  late TextEditingController _kasusKalahController;

  late List<String> _selectedBidangKeahlian;
  late List<DataBulanan> _dataBulanan;
  late List<Perkara> _perkaraSelesai;
  late List<Perkara> _perkaraBerjalan;

  bool _isSubmitting = false;

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

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.advokat.nama);
    _fotoController = TextEditingController(text: widget.advokat.foto);
    _wilayahController =
        TextEditingController(text: widget.advokat.wilayahPraktik);
    _kotaController = TextEditingController(text: widget.advokat.kota);
    _deskripsiController =
        TextEditingController(text: widget.advokat.deskripsi);
    _pengalamanController =
        TextEditingController(text: widget.advokat.pengalaman.toString());
    _jumlahKasusController = TextEditingController(
        text: widget.advokat.statistik.jumlahKasus.toString());
    _kasusSelesaiController = TextEditingController(
        text: widget.advokat.statistik.kasusSelesai.toString());
    _kasusMenangController = TextEditingController(
        text: widget.advokat.statistik.kasusMenang.toString());
    _kasusKalahController = TextEditingController(
        text: widget.advokat.statistik.kasusKalah.toString());

    _selectedBidangKeahlian = List.from(widget.advokat.bidangKeahlian);
    _dataBulanan = List.from(widget.advokat.statistik.dataBulanan);

    // 🔥 NEW: Load existing perkara
    _perkaraSelesai = List.from(widget.advokat.riwayat.perkaraSelesai);
    _perkaraBerjalan = List.from(widget.advokat.riwayat.perkaraBerjalan);
  }

  // 🔥 NEW: Add Data Bulanan Dialog
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
                  hintText: 'Jan, Feb, Mar...',
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

  // 🔥 NEW: Add Perkara Dialog
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
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tahunController,
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBidangKeahlian.isEmpty) {
      _showSnackBar('Pilih minimal 1 bidang keahlian', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final jumlahKasus = int.parse(_jumlahKasusController.text);
      final kasusSelesai = int.parse(_kasusSelesaiController.text);
      final kasusMenang = int.parse(_kasusMenangController.text);
      final kasusKalah = int.parse(_kasusKalahController.text);

      final winRate =
          kasusSelesai > 0 ? (kasusMenang / kasusSelesai) * 100 : 0.0;
      final kasusMenunggu = jumlahKasus - kasusSelesai;

      // 🔥 NEW: Include riwayat in update
      final updatedAdvokat = Advokat(
        id: widget.advokat.id,
        nama: _namaController.text,
        foto: _fotoController.text,
        wilayahPraktik: _wilayahController.text,
        kota: _kotaController.text,
        deskripsi: _deskripsiController.text,
        pengalaman: int.parse(_pengalamanController.text),
        bidangKeahlian: _selectedBidangKeahlian,
        statistik: Statistik(
          jumlahKasus: jumlahKasus,
          kasusSelesai: kasusSelesai,
          kasusMenunggu: kasusMenunggu,
          kasusMenang: kasusMenang,
          kasusKalah: kasusKalah,
          winRate: winRate,
          dataBulanan: _dataBulanan,
        ),
        riwayat: RiwayatPerkara(
          perkaraSelesai: _perkaraSelesai,
          perkaraBerjalan: _perkaraBerjalan,
        ),
      );

      print('📤 Updating advokat with riwayat perkara');
      print('   - Perkara Selesai: ${_perkaraSelesai.length}');
      print('   - Perkara Berjalan: ${_perkaraBerjalan.length}');

      await _advokatService.updateAdvokat(widget.advokat.id, updatedAdvokat);

      if (!mounted) return;

      _showSnackBar('Data advokat berhasil diupdate', isError: false);
      Navigator.pop(context, true);
    } catch (e) {
      print('❌ Error updating advokat: $e');
      _showSnackBar('Gagal mengupdate advokat: $e', isError: true);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Advokat'),
        backgroundColor: const Color(0xFF212121),
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
                  icon: Icons.person,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fotoController,
                  label: 'URL Foto',
                  icon: Icons.link,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _wilayahController,
                  label: 'Wilayah Praktik',
                  icon: Icons.location_on,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wilayah wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _kotaController,
                  label: 'Kota',
                  icon: Icons.location_city,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Kota wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _pengalamanController,
                  label: 'Pengalaman (Tahun)',
                  icon: Icons.work,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Wajib diisi';
                    if (int.tryParse(value!) == null)
                      return 'Harus berupa angka';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _deskripsiController,
                  label: 'Deskripsi',
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Deskripsi wajib diisi' : null,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Bidang Keahlian', Icons.school),
                _buildBidangKeahlianSelector(),

                const SizedBox(height: 24),
                _buildSectionTitle('Statistik Kinerja', Icons.bar_chart),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField(
                      controller: _jumlahKasusController,
                      label: 'Total Kasus',
                      icon: Icons.gavel,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Wajib';
                        if (int.tryParse(value!) == null) return 'Angka';
                        return null;
                      },
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildTextField(
                      controller: _kasusSelesaiController,
                      label: 'Selesai',
                      icon: Icons.check_circle,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Wajib';
                        if (int.tryParse(value!) == null) return 'Angka';
                        return null;
                      },
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField(
                      controller: _kasusMenangController,
                      label: 'Menang',
                      icon: Icons.emoji_events,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Wajib';
                        if (int.tryParse(value!) == null) return 'Angka';
                        return null;
                      },
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildTextField(
                      controller: _kasusKalahController,
                      label: 'Kalah',
                      icon: Icons.close,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Wajib';
                        if (int.tryParse(value!) == null) return 'Angka';
                        return null;
                      },
                    )),
                  ],
                ),

                // 🔥 NEW: Data Bulanan Section
                const SizedBox(height: 24),
                _buildSectionTitle('Data Kasus Bulanan', Icons.show_chart),
                _buildDataBulananList(),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _showAddDataBulananDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Data Bulan'),
                ),

                // 🔥 NEW: Riwayat Perkara Section
                const SizedBox(height: 24),
                _buildSectionTitle('Riwayat Perkara', Icons.history),
                _buildPerkaraList('Perkara Selesai', _perkaraSelesai, true),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showAddPerkaraDialog(true),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Perkara Selesai'),
                ),
                const SizedBox(height: 16),
                _buildPerkaraList('Perkara Berjalan', _perkaraBerjalan, false),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showAddPerkaraDialog(false),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Perkara Berjalan'),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
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
                            color: Color(0xFF212121),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
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
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildDataBulananList() {
    if (_dataBulanan.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Belum ada data bulanan',
            style: TextStyle(color: Colors.grey.shade600),
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
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final data = _dataBulanan[index];
          return ListTile(
            title: Text(data.bulan),
            subtitle: Text(
                'Kasus: ${data.jumlahKasus}, Selesai: ${data.kasusSelesai}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _dataBulanan.removeAt(index)),
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
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (perkara.isEmpty)
              Text('Belum ada perkara',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12))
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
                    onPressed: () => setState(() => perkara.removeAt(index)),
                  ),
                );
              }).toList(),
          ],
        ),
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
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            const Text('Pilih bidang keahlian:',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
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
