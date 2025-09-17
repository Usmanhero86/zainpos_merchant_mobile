import 'package:flutter/material.dart';
import '../../../app/models/terminal_model.dart';
import '../../../widgets/terminal_card.dart';

class TerminalsTab extends StatefulWidget {
  const TerminalsTab({super.key});

  @override
  State<TerminalsTab> createState() => _TerminalsTabState();
}

class _TerminalsTabState extends State<TerminalsTab> {
  final List<Terminal> terminals = [
    Terminal(status: 'ACTIVE',   number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'INACTIVE', number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'INACTIVE', number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'INACTIVE', number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'ACTIVE',   number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'INACTIVE', number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'ACTIVE',   number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
    Terminal(status: 'ACTIVE',   number: '4421619007', name: 'Nassarawa Terminal', id: 'ZNP0526952855'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text('Terminals', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){}, icon:  Image(
            height: 16, width: 16,
            image: AssetImage('assets/logos/searchIcon.png'),
          ),),
          IconButton(onPressed: (){}, icon:  Image(
            height: 16, width: 16,
            image: AssetImage('assets/logos/filterIcon.png'),
          ),),
        ],
      ),
      body: ListView.separated(
        itemCount: terminals.length,
        itemBuilder: (context, index) {
          final terminal = terminals[index];
          return TerminalCard(terminal: terminal);
        },
        separatorBuilder: (context, index) =>  Divider(
          color: Colors.grey[200],
          thickness: 1,
          height: 1,
        ),
      ),
    );
  }
}
