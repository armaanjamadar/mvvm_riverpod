import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mvvm_riverpod_movies_app/repository/movies_repo.dart';
import 'package:mvvm_riverpod_movies_app/view_models/movies/movies_state.dart';
import '../../models/movies_model.dart';
import '../../services/init_getit.dart';

final moviesProvider = StateNotifierProvider<MoviesProvider, MoviesState>(
  (_) => MoviesProvider(),
);

final currentMovie = Provider.family<MovieModel, int>((ref, index) {
  final movieState = ref.watch(moviesProvider);
  return movieState.moviesList[index];
});

class MoviesProvider extends StateNotifier<MoviesState> {

  MoviesProvider() : super(MoviesState());

  final MoviesRepository _moviesRepository = getIt<MoviesRepository>();

  Future<void> getMovies() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      if (state.genresList.isEmpty) {
        final genresList = await _moviesRepository.fetchGenres();
        state = state.copyWith(genresList: genresList);
      }
      List<MovieModel> movies = await _moviesRepository.fetchMovies(page: state.currentPage);
      state = state.copyWith(
        moviesList: [...state.moviesList, ...movies],
        currentPage: state.currentPage + 1,
        fetchMoviesError: '',
      );
    } catch (error) {
      state = state.copyWith(fetchMoviesError: error.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}