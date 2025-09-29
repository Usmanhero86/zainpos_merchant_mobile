import 'package:flutter/material.dart';
import '../../app/models/terminal_model.dart';
import '../models/response_model/auth_response.dart';
import 'api_service.dart';

class ApiProvider extends ChangeNotifier {
  final api = ApiService();

  bool loading = false;
  AuthResponse? user;
  List<Terminal> terminals = [];

}
