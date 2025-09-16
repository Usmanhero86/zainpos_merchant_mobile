import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/searchs/search_and_filter.dart';
import 'package:zainpos_merchant_mobile/screens/settings/settings_screen.dart';
import 'package:zainpos_merchant_mobile/screens/transfers/transfer_screen.dart';

class NassarawaTerminalScreen extends StatelessWidget {
  const NassarawaTerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final basePadding = isTablet ? 24.0 : 16.0;
    final titleSize = isTablet ? 20.0 : 16.0;
    final cardIconSize = isTablet ? 48.0 : 38.0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Nassarawa Terminal 1',
            style: TextStyle(fontSize: titleSize + 2),
          ),
          actions: [
            IconButton(
              onPressed: () => showSearchFilterBottomSheet(context),
              icon: Image.asset('assets/logos/searchIcon.png',
                  height: 24, width: 24),
            ),
            SizedBox(width: basePadding / 2),
            IconButton(
              onPressed: () => showSettingsBottomSheet(context),
              icon: Image.asset('assets/logos/settings-02.png',
                  height: 24, width: 24),
            ),
            SizedBox(width: basePadding / 2),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransferScreen()),
            );
          },
          child: Image.asset('assets/logos/sendIcon.png', height: 24, width: 24),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final tabHeight = maxWidth > 600 ? 400.0 : 300.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(basePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Virtual Account + Wallet
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(basePadding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/logos/FeaturedIcon(1).png',
                                height: cardIconSize,
                                width: cardIconSize,
                              ),
                              SizedBox(width: basePadding),
                              Expanded(
                                child: Text(
                                  'Virtual Account Number\n269528555 - Wema Bank',
                                  style: TextStyle(fontSize: titleSize),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: basePadding),
                          Row(
                            children: [
                              Image.asset(
                                'assets/logos/wallet-02.png',
                                height: cardIconSize,
                                width: cardIconSize,
                              ),
                              SizedBox(width: basePadding),
                              Expanded(
                                child: Text(
                                  'Wallet Balance\n₦23,090,180.00',
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: basePadding),

                  // Transactions header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                            fontSize: titleSize, fontWeight: FontWeight.w600),
                      ),
                      Chip(
                        label: Text(
                          '320 Transactions',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                        backgroundColor: const Color(0xFFEAF1FF),
                      ),
                    ],
                  ),
                  SizedBox(height: basePadding / 2),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.black,
                      labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      tabs: const [
                        Tab(text: 'POS Transfer'),
                        Tab(text: 'Card'),
                        Tab(text: 'Fund Transfer'),
                      ],
                    ),
                  ),
                  SizedBox(height: basePadding / 2),

                  // Transactions list
                  SizedBox(
                    height: tabHeight,
                    child: const TabBarView(
                      children: [
                        TransactionList(),
                        TransactionList(),
                        TransactionList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SettingsScreen(
      initialTransfersEnabled: true,
      initialBalanceEnabled: true,
      initialReprintEnabled: false,
      onSettingsApplied: (settings) {
        // handle settings
      },
    ),
  );
}

void showSearchFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const SearchAndFilterScreen(),
  );
}

/// Responsive Transaction List
class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;
    final titleSize = isTablet ? 18.0 : 16.0;
    final subSize = isTablet ? 14.0 : 12.0;

    final transactions = List.generate(4, (index) => '₦22,500.00');

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            transactions[index],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize),
          ),
          subtitle: Text(
            'TRN-REF 269528555  •  2024-02-16',
            style: TextStyle(fontSize: subSize),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}
