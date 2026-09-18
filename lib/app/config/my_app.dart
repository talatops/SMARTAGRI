import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final router = ref.watch(
      appRouterProvider,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      title: 'Smart Agriculture System',

      routerConfig: router,

      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}