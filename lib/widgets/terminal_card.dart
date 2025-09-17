import 'package:flutter/material.dart';
import '../app/models/terminal_model.dart';
import '../screens/terminal/nassarawa_terminal.dart';

class TerminalCard extends StatelessWidget {
  final Terminal terminal;

  const TerminalCard({super.key, required this.terminal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.white,
      onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>
          NassarawaTerminalScreen())),
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(onPressed: () {

                    },
                      icon: Icon(Icons.arrow_forward_ios),),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8),
            // Terminal name
            Text(
              terminal.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
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
      ),
    );
  }
}