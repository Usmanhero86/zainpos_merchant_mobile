import '../app/models/terminal_model.dart';
import '../services/models/response_model/terminal_response.dart';

extension TerminalsMapper on Terminals {
  Terminal toCardModel() {
    return Terminal(
      status: isActive == true ? 'ACTIVE' : 'INACTIVE',
      number: virtualAccountNumber ?? 'N/A',
      name: terminalName ?? 'Unnamed Terminal',
      id: terminalId ?? 'N/A',
    );
  }
}