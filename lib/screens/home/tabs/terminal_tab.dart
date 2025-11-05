import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/terminal_provider.dart';
import '../../../widgets/terminal_card.dart';

class TerminalsTab extends StatefulWidget {
  const TerminalsTab({super.key});

  @override
  State<TerminalsTab> createState() => _TerminalsTabState();
}

class _TerminalsTabState extends State<TerminalsTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TerminalProvider>().fetchTerminals();
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<TerminalProvider>().searchTerminals(query);
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        context.read<TerminalProvider>().clearSearch();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<TerminalProvider>().clearSearch();
  }

  void _applyFilter(TerminalFilter filter) {
    context.read<TerminalProvider>().applyFilter(filter);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: _showSearchBar
            ? IconButton(
          icon: Icon(Icons.arrow_back, size: w * 0.07, color: Colors.black87),
          onPressed: _toggleSearchBar,
        )
            : null,
        title: _showSearchBar
            ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name, ID, account, status...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: _clearSearch,
              )
                  : null,
            ),
          ),
        )
            : const Text(
          'Terminals',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        actions: _showSearchBar
            ? [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: _toggleSearchBar,
          ),
        ]
            : [
          IconButton(
            onPressed: _toggleSearchBar,
            icon: const Image(
              height: 24,
              width: 24,
              image: AssetImage('assets/logos/searchIcon.png'),
            ),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Image(
              height: 18,
              width: 12,
              image: AssetImage('assets/logos/filterIcon.png'),
            ),
          ),
        ],
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, terminalProvider, child) {
          final displayTerminals = terminalProvider.searchQuery.isNotEmpty ||
              terminalProvider.currentFilter != TerminalFilter.all
              ? terminalProvider.filteredTerminals
              : terminalProvider.terminals;

          // Search info header
          Widget? searchInfo;
          if (terminalProvider.searchQuery.isNotEmpty ||
              terminalProvider.currentFilter != TerminalFilter.all) {
            searchInfo = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _buildSearchInfo(terminalProvider),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (terminalProvider.searchQuery.isNotEmpty ||
                      terminalProvider.currentFilter != TerminalFilter.all)
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.blue),
                      onPressed: () {
                        _clearSearch();
                        context.read<TerminalProvider>().applyFilter(TerminalFilter.all);
                      },
                    ),
                ],
              ),
            );
          }

          if (terminalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (terminalProvider.error != null) {
            return _buildErrorState(terminalProvider.error!);
          }

          if (displayTerminals.isEmpty) {
            return _buildEmptyState(
              terminalProvider.searchQuery.isNotEmpty ||
                  terminalProvider.currentFilter != TerminalFilter.all,
            );
          }

          return Column(
            children: [
              if (searchInfo != null) searchInfo,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => terminalProvider.refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayTerminals.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final terminal = displayTerminals[index]; // Use directly, no mapping needed
                      return TerminalCard(terminal: terminal);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _buildSearchInfo(TerminalProvider provider) {
    final hasSearch = provider.searchQuery.isNotEmpty;
    final hasFilter = provider.currentFilter != TerminalFilter.all;

    if (hasSearch && hasFilter) {
      return 'Showing ${provider.filteredTerminals.length} terminals for "${provider.searchQuery}" (${provider.currentFilter.displayName})';
    } else if (hasSearch) {
      return 'Showing ${provider.filteredTerminals.length} terminals for "${provider.searchQuery}"';
    } else if (hasFilter) {
      return 'Showing ${provider.filteredTerminals.length} ${provider.currentFilter.displayName.toLowerCase()} terminals';
    }

    return 'Showing all terminals';
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load terminals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<TerminalProvider>().fetchTerminals();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.point_of_sale,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No Terminals Found' : 'No Terminals Available',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try adjusting your search or filter criteria'
                  : 'Your terminals will appear here once they are registered',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _clearSearch();
                  context.read<TerminalProvider>().applyFilter(TerminalFilter.all);
                },
                child: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;

    if (isLargeScreen) {
      // 🖥️ Use dialog for large screens
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.all(24),
            child: Consumer<TerminalProvider>(
              builder: (context, provider, child) {
                final stats = provider.statistics;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Filter Terminals',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          Text(
                            '${stats['total']} terminals found',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 16),

                          // Filter options
                          ...TerminalFilter.values.map((filter) {
                            final count = _getFilterCount(provider, filter);
                            final selected = provider.currentFilter == filter;

                            return ListTile(
                              leading: Icon(
                                filter.icon,
                                color: selected ? Colors.blue : Colors.grey,
                                size: 26,
                              ),
                              title: Text(
                                filter.displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                  color: selected ? Colors.blue : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                '$count terminals • ${filter.description}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              trailing: selected
                                  ? const Icon(Icons.check, color: Colors.blue)
                                  : null,
                              onTap: () {
                                _applyFilter(filter);
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),

                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear Filter'),
                              onPressed: () {
                                _applyFilter(TerminalFilter.all);
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      // 📱 Use bottom sheet for small screens
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Consumer<TerminalProvider>(
            builder: (context, provider, child) {
              final stats = provider.statistics;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Text(
                      'Filter Terminals',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${stats['total']} terminals found',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Filter options
                    ...TerminalFilter.values.map((filter) {
                      final count = _getFilterCount(provider, filter);
                      final selected = provider.currentFilter == filter;

                      return ListTile(
                        leading: Icon(
                          filter.icon,
                          color: selected ? Colors.blue : Colors.grey,
                        ),
                        title: Text(filter.displayName),
                        subtitle: Text(
                          '$count terminals • ${filter.description}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: selected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          _applyFilter(filter);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Filter'),
                        onPressed: () {
                          _applyFilter(TerminalFilter.all);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  int _getFilterCount(TerminalProvider provider, TerminalFilter filter) {
    switch (filter) {
      case TerminalFilter.all:
        return provider.terminals.length;
      case TerminalFilter.active:
        return provider.terminals.where((t) => t.isActive == true).length;
      case TerminalFilter.inactive:
        return provider.terminals.where((t) => t.isActive == false).length;
      case TerminalFilter.transferEnabled:
        return provider.terminals.where((t) => t.transferEnabled == true).length;
      case TerminalFilter.balanceEnabled:
        return provider.terminals.where((t) => t.viewBalanceEnabled == true).length;
      case TerminalFilter.reprintEnabled:
        return provider.terminals.where((t) => t.reprintEnabled == true).length;
    }
  }
}