// lib/screens/home_screen.dart (WITH UPDATE & DELETE INTEGRATION)
import 'package:flutter/material.dart';
import '../models/advokat_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/advokat_service.dart';
import '../widgets/advokat_image.dart';
import 'detail_advokat_screen.dart';
import 'add_advokat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Advokat> advokatList = [];
  List<Advokat> filteredList = [];
  String selectedKota = 'Semua Kota';
  String selectedBidang = 'Semua Bidang';
  User? currentUser;

  final AuthService _authService = AuthService();
  final AdvokatService _advokatService = AdvokatService();

  bool _isLoadingUser = true;
  bool _isLoadingAdvokat = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadAdvokat();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      currentUser = user;
      _isLoadingUser = false;
    });
  }

  Future<void> _loadAdvokat() async {
    setState(() => _isLoadingAdvokat = true);

    try {
      final advokat = await _advokatService.getAllAdvokat(
        kota: selectedKota != 'Semua Kota' ? selectedKota : null,
        bidang: selectedBidang != 'Semua Bidang' ? selectedBidang : null,
      );

      setState(() {
        advokatList = advokat;
        filteredList = advokat;
        _isLoadingAdvokat = false;
      });

      print('✅ Loaded ${advokat.length} advokat');
    } catch (e) {
      print('❌ Error loading advokat: $e');
      setState(() => _isLoadingAdvokat = false);
    }
  }

  void _filterAdvokat() {
    _loadAdvokat();
  }

  Future<void> _handleMenuSelection(String value) async {
    if (value == 'logout') {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = currentUser?.isAdmin() ?? false;

    print(
        '🏗️ Building HomeScreen - Loading: $_isLoadingAdvokat, Items: ${filteredList.length}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Daftar Advokat',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
        actions: [
          if (!_isLoadingUser && currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  const Icon(Icons.account_circle, color: Color(0xFFFFD700)),
                  const SizedBox(width: 4),
                  Text(
                    currentUser!.nama ?? 'User',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFFFFD700)),
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAdvokatScreen(
                      onAdvokatAdded: () {
                        print('🔄 Refreshing advokat list after add...');
                        _loadAdvokat();
                      },
                    ),
                  ),
                );
              },
              backgroundColor: Colors.black,
              icon: const Icon(Icons.add, color: Color(0xFFFFD700)),
              label: const Text(
                'Tambah Advokat',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(),
          Expanded(
            child: _isLoadingAdvokat
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                    ? _buildEmptyState()
                    : _buildAdvokatList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Pencarian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: selectedKota,
                  items: const [
                    'Semua Kota',
                    'Jakarta',
                    'Surabaya',
                    'Bandung',
                    'Yogyakarta',
                    'Medan',
                    'Denpasar',
                    'Semarang'
                  ],
                  onChanged: (v) {
                    setState(() => selectedKota = v!);
                    _filterAdvokat();
                  },
                  hint: 'Pilih Kota',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  value: selectedBidang,
                  items: const [
                    'Semua Bidang',
                    'Hukum Pidana',
                    'Hukum Perdata',
                    'Hukum Bisnis',
                    'Hukum Keluarga',
                    'Hukum Waris',
                    'Hukum Korporat',
                    'Hukum HAM',
                    'Hukum Lingkungan',
                  ],
                  onChanged: (v) {
                    setState(() => selectedBidang = v!);
                    _filterAdvokat();
                  },
                  hint: 'Pilih Bidang',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(hint, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildAdvokatList() {
    print('🎨 Building advokat list with ${filteredList.length} items');

    return RefreshIndicator(
      onRefresh: _loadAdvokat,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final advokat = filteredList[index];
          print('📝 Building card for: ${advokat.nama}');
          return _buildAdvokatCard(advokat);
        },
      ),
    );
  }

  // 🔥 UPDATED: Tambahkan callback untuk refresh setelah update/delete
  Widget _buildAdvokatCard(Advokat advokat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFFFFF),
      child: InkWell(
        onTap: () async {
          // 🔥 NEW: Await result dan refresh jika ada perubahan
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAdvokatScreen(
                advokat: advokat,
                // 🔥 NEW: Callback untuk refresh list
                onAdvokatChanged: () {
                  print('🔄 Advokat changed, refreshing list...');
                  _loadAdvokat();
                },
              ),
            ),
          );

          // 🔥 NEW: Refresh jika advokat dihapus (result == true)
          if (result == true) {
            print('🗑️ Advokat deleted, refreshing list...');
            _loadAdvokat();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                child: ClipOval(
                  child: AdvokatImage(
                    imagePath: advokat.foto,
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advokat.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            advokat.wilayahPraktik,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: advokat.bidangKeahlian.take(2).map((bidang) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            bidang,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatChip(
                          Icons.work,
                          '${advokat.pengalaman} Tahun',
                          color: Colors.black26,
                        ),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          Icons.trending_up,
                          '${advokat.statistik.winRate.toStringAsFixed(1)}% Win',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada advokat ditemukan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Coba ubah filter pencarian',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
