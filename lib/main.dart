import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'core/models/adherence_log.dart';
import 'features/medications/repository/adherence_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cthivwsfacrxvetsfaal.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0aGl2d3NmYWNyeHZldHNmYWFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI4MjQ1MzEsImV4cCI6MjA4ODQwMDUzMX0.u1Fwew26SUaOGv6oIPCFdIa2yej-pxi5WBm49B8rYR4',
  );

  await Hive.initFlutter();

  // Pre-open the offline adherence queue box.
  final adherenceRepo = AdherenceRepository();
  await adherenceRepo.init();

  await NotificationService.instance.init(
    onTap: (scheduleEntryId) async {
      // Guard: only log if the user still has a valid session.
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      try {
        await adherenceRepo.logDose(
          scheduleEntryId: scheduleEntryId,
          scheduledAt: DateTime.now(),
          status: AdherenceStatus.taken,
          takenAt: DateTime.now(),
        );
      } catch (_) {
        // Swallow silently — will be retried from offline queue on next sync.
      }
    },
  );

  runApp(const App());
}
