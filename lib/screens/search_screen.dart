import 'package:flutter/material.dart';
import '../models/advokat_model.dart';
import '../widgets/advokat_image.dart';
import 'detail_advokat_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Advokat> advokatList;

  const SearchScreen({Key? key, required this.advokatList}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Advokat> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchResults = widget.advokatList;
  }

  void _performSearch(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        searchResults = widget.advokatList;
      } else {
        searchResults = widget.advokatList.where((advokat) {
          final nameLower = advokat.nama.toLowerCase();
          final kotaLower = advokat.kota.toLowerCase();
          final wilayahLower = advokat.wilayahPraktik.toLowerCase();
          final queryLower = query.toLowerCase();

          // Cek bidang keahlian
          bool bidangMatch = advokat.bidangKeahlian.any(
                (bidang) => bidang.toLowerCase().contains(queryLower),
          );

          return nameLower.contains(queryLower) ||
              kotaLower.contains(queryLower) ||
              wilayahLower.contains(queryLower) ||
              bidangMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Advokat'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: searchResults.isEmpty
                ? _buildEmptyState()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Cari nama, kota, atau bidang hukum...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: isSearching
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final advokat = searchResults[index];
        return _buildAdvokatCard(advokat);
      },
    );
  }

  Widget _buildAdvokatCard(Advokat advokat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAdvokatScreen(advokat: advokat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(advokat.foto),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advokat.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          advokat.wilayahPraktik,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
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
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            bidang,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${advokat.statistik.winRate.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  const Text(
                    'Win Rate',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.search,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Tidak ada hasil pencarian'
                : 'Mulai cari advokat',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Coba kata kunci lain'
                : 'Ketik nama, kota, atau bidang hukum',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}