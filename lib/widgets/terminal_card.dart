import 'package:flutter/material.dart';

import '../app/models/terminal_model.dart';
import '../screens/terminal/nassarawa_terminal.dart';

class TerminalCard extends StatelessWidget {
  final Terminal terminal;

  const TerminalCard({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: terminal.status == 'ACTIVE'
                      ? Colors.green
                      : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
               SizedBox(width: 8),
              Expanded(
                child: Text(
                  terminal.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: terminal.status == 'ACTIVE'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    terminal.number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        NassarawaTerminalScreen()));
                  }, icon: Icon(Icons.arrow_forward_ios),),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),
          // Terminal name
          Text(
            terminal.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          // ID label and value
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(
                  text: 'ID: ',
                  style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(text: terminal.id, style: TextStyle(
                  color: Colors.grey
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}