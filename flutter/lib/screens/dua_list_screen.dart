import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/dua_item.dart';
import '../services/dua_service.dart';
import 'dua_detail_screen.dart';

class DuaListScreen extends StatefulWidget {
  const DuaListScreen({super.key});

  @override
  State<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  final DuaService _duaService = DuaService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'all';
  bool _onlyFavourites = false;
  List<DuaItem> _displayedDuas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _duaService.init();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    _displayedDuas = _duaService.filter(
      categoryKey: _selectedCategory,
      searchQuery: _searchController.text,
      onlyFavourites: _onlyFavourites,
    );
  }

  void _onCategorySelected(String key) {
    setState(() {
      _selectedCategory = key;
      _applyFilters();
    });
  }

  void _toggleFavouritesFilter() {
    setState(() {
      _onlyFavourites = !_onlyFavourites;
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'দোয়া ও সূরা',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _onlyFavourites ? 'সকল দেখুন' : 'প্রিয় তালিকা',
            icon: Icon(
              _onlyFavourites ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _onlyFavourites ? AppColors.goldLight : AppColors.textSecondary,
            ),
            onPressed: _toggleFavouritesFilter,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            )
          : Column(
              children: [
                // Search Field & Quick Favourites Badge
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  color: AppColors.surface,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'দোয়া বা সূরা খুঁজুন (বাংলা / English)...',
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _applyFilters());
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppColors.card,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.cardBorder.withAlpha(120)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.cardBorder.withAlpha(120)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
                          ),
                        ),
                        onChanged: (_) => setState(() => _applyFilters()),
                      ),
                    ],
                  ),
                ),

                // Horizontal Categories Selector
                Container(
                  height: 48,
                  color: AppColors.surface,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    itemCount: DuaService.categories.length,
                    itemBuilder: (context, index) {
                      final cat = DuaService.categories[index];
                      final isSelected = _selectedCategory == cat.key;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(cat.titleBn),
                          selected: isSelected,
                          onSelected: (_) => _onCategorySelected(cat.key),
                          selectedColor: AppColors.gold,
                          backgroundColor: AppColors.card,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF041A13) : AppColors.textPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? AppColors.gold : AppColors.cardBorder.withAlpha(100),
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),

                // Active filter summary banner
                if (_onlyFavourites)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.gold.withAlpha(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.bookmark_rounded, size: 16, color: AppColors.goldLight),
                            SizedBox(width: 8),
                            Text(
                              'সংরক্ষিত (প্রিয়) দোয়াসমূহ ফিল্টার করা হয়েছে',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleFavouritesFilter,
                          child: const Text(
                            'সকল দেখুন',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.emeraldLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Duas List
                Expanded(
                  child: _displayedDuas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.menu_book_outlined,
                                size: 54,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _onlyFavourites
                                    ? 'কোনো প্রিয় দোয়া বা সূরা সংরক্ষিত নেই'
                                    : 'কোনো ফলাফল পাওয়া যায়নি',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _onlyFavourites
                                    ? 'যেকোনো দোয়ার বুকমার্ক আইকনে ক্লিক করে সংরক্ষণ করুন।'
                                    : 'ভিন্ন শব্দ দিয়ে অনুসন্ধান করে চেষ্টা করুন।',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: _displayedDuas.length,
                          itemBuilder: (context, index) {
                            final item = _displayedDuas[index];
                            final isFav = _duaService.isFavourite(item.slug);

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              color: AppColors.card,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isFav
                                      ? AppColors.gold.withAlpha(120)
                                      : AppColors.cardBorder.withAlpha(90),
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DuaDetailScreen(
                                        item: item,
                                        onFavouriteToggled: () {
                                          setState(() => _applyFilters());
                                        },
                                      ),
                                    ),
                                  );
                                  setState(() => _applyFilters());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.surface,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                          color: AppColors.gold.withAlpha(60),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        item.getCategoryTitleBn(),
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.goldLight,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  item.titleBn,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  item.titleEn,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isFav
                                                  ? Icons.bookmark_rounded
                                                  : Icons.bookmark_border_rounded,
                                              color: isFav ? AppColors.goldLight : AppColors.textMuted,
                                              size: 22,
                                            ),
                                            onPressed: () async {
                                              await _duaService.toggleFavourite(item.slug);
                                              setState(() => _applyFilters());
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Short Arabic Preview
                                      Text(
                                        item.arabic,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 18,
                                          color: AppColors.emeraldLight,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.reference,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                          const Row(
                                            children: [
                                              Text(
                                                'পড়ুন',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.gold,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Icon(
                                                Icons.chevron_right_rounded,
                                                size: 16,
                                                color: AppColors.gold,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
