import 'package:flutter/material.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/show_filter.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/show_settings.dart';
import 'package:zainpos_merchant_mobile/screens/terminal/widgets/transaction_list.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
              MaterialPageRoute(builder: (_) => TransferScreen()),
            );
          },
          child: Image.asset('assets/logos/sendIcon.png', height: 24, width: 24),
        ),
        body: LayoutBuilder(
          builder: (context, raints) {
            final maxWidth =raints.maxWidth;
            final tabHeight = maxWidth > 600 ? 400.0 : 300.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(basePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              Column(
                                children: [
                                  Text(
                                    'Virtual Account Number',
                                    style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '269528555 - Wema Bank',
                                    style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: basePadding),
                          Row(
                            children: [
                              Image.asset(
                                'assets/logos/FeaturedIconW.png',
                                height: cardIconSize,
                                width: cardIconSize,
                              ),
                              SizedBox(width: basePadding),
                              Column(
                                children: [
                                  Text(
                                    'Wallet Balance',
                                    style: TextStyle(
                                      fontSize: titleSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text('₦23,090,180.00',
                                    style: TextStyle(
                                      fontSize: titleSize,
                                      fontWeight: FontWeight.bold,
                                    ),)
                                ],
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
                        backgroundColor: Color(0xFFEAF1FF),
                      ),
                    ],
                  ),
                  SizedBox(height: basePadding / 2),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        TabBar(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.tab,

                          indicator: BoxDecoration(
                            color: Color(0xFFEFEFEF),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          tabs: const [
                            Tab(text: 'POS Transfer'),
                            Tab(text: 'Card'),
                            Tab(text: 'Fund Transfer'),
                          ],
                        ),

                        // vertical dividers stay on top
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Row(
                              children: const [
                                Expanded(child: SizedBox()),
                                VerticalDivider(width: 1, color: Colors.grey),
                                Expanded(child: SizedBox()),
                                VerticalDivider(width: 1, color: Colors.grey),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: basePadding / 2),

                  // Transactions list
                  SizedBox(
                    height: tabHeight,
                    child: TabBarView(
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



