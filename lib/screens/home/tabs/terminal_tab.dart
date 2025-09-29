import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zainpos_merchant_mobile/mappers/terminal_mapper.dart';
import '../../../provider/terminal_provider.dart';
import '../../../widgets/terminal_card.dart';

class TerminalsTab extends StatefulWidget {
  const TerminalsTab({super.key});

  @override
  State<TerminalsTab> createState() => _TerminalsTabState();
}

class _TerminalsTabState extends State<TerminalsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TerminalProvider>().fetchTerminals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Terminals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSearchDialog(context),
            icon: const Image(
              height: 16,
              width: 16,
              image: AssetImage('assets/logos/searchIcon.png'),
            ),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Image(
              height: 16,
              width: 16,
              image: AssetImage('assets/logos/filterIcon.png'),
            ),
          ),
        ],
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, terminalProvider, child) {
          if (terminalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (terminalProvider.error != null) {
            return _buildErrorState(terminalProvider.error!);
          }

          final terminals = terminalProvider.terminals;
          if (terminals.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => terminalProvider.refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: terminals.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final apiTerminal = terminals[index];

                // Convert API Terminals to UI Terminal
                final cardTerminal = apiTerminal.toCardModel();

                return TerminalCard(terminal: cardTerminal);
              },
            ),
          );
        },
      ),
    );
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.point_of_sale, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Terminals Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your terminals will appear here once they are registered',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Terminals'),
        content: const Text('Search functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Terminals'),
        content: const Text('Filter functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}