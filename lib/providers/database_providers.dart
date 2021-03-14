import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo_firebase/services/database_services.dart';

final databaseProvider = Provider((ref) => Database());
