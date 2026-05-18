import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../widgets/item_card.dart';
import 'add_edit_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ItemProvider>().loadItems());
  }

  void _openForm({item}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemScreen(item: item)),
    ).then((_) => context.read<ItemProvider>().loadItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();

    // Exact colors from the photo
    const headerTop = Color(0xFF00756A);
    const headerBottom = Color(0xFF269088);
    const bgColor = Color(0xFFF2F6F5);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [headerTop, headerBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Campus Lost & Found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Find or report lost items on campus',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Filter chips row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', 'Lost', 'Found', 'Active', 'Claimed']
                            .map((f) {
                          final selected = provider.selectedFilter == f;
                          return GestureDetector(
                            onTap: () => provider.setFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF26908A),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? Colors.transparent
                                      : Colors.white38,
                                ),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  color: selected
                                      ? headerTop
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Search bar
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: provider.setSearchQuery,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey.shade400, size: 20),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off_rounded,
                                size: 56, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(provider.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey.shade600)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: provider.loadItems,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: headerTop,
                                  foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : provider.items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.inbox_rounded,
                                    size: 64,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 10),
                                Text('No items found',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade500)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                12, 14, 12, 90),
                            itemCount: provider.items.length,
                            itemBuilder: (context, index) {
                              final item = provider.items[index];
                              return ItemCard(
                                item: item,
                                onEdit: () => _openForm(item: item),
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text('Delete Item'),
                                      content: const Text(
                                          'Are you sure you want to delete this item?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () => Navigator.pop(
                                              context, true),
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true && item.id != null) {
                                    await provider.removeItem(item.id!);
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: headerTop,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Report Item',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
