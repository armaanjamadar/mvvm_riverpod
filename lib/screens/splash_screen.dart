import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_riverpod_movies_app/services/navigation_service.dart';
import 'package:mvvm_riverpod_movies_app/view_models/movies/movies_provider.dart';
import 'package:mvvm_riverpod_movies_app/widgets/my_error_widget.dart';
import '../services/init_getit.dart';
import '../view_models/favorites/favorites_provider.dart';
import 'movies_screen.dart';


final initializationProvider = FutureProvider.autoDispose<void>((ref) async {
  ref.keepAlive();
  await Future.microtask(() async {
    await ref.read(favoritesProvider.notifier).loadFavorites();
    await ref.read(moviesProvider.notifier).getMovies();
  });
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initWatch = ref.watch(initializationProvider);
    return Scaffold(
      body: initWatch.when(
        data: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            getIt<NavigationService>().navigateReplace(const MoviesScreen());
          });
          return SizedBox.shrink();
        },
        error: (error, _) {
          return MyErrorWidget(
            errorText: error.toString(),
            retryFunction: () => ref.refresh(initializationProvider),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
