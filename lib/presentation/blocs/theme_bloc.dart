import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinform_online/config/theme/app_theme.dart';

// Eventos
abstract class ThemeEvent {}

class ThemeToggled extends ThemeEvent {}

// Estados
class ThemeState {
  final ThemeData themeData;
  final ThemeMode themeMode;

  ThemeState({required this.themeData, required this.themeMode});
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(
        ThemeState(themeData: AppTheme.lightTheme, themeMode: ThemeMode.light),
      ) {
    on<ThemeToggled>((event, emit) {
      if (state.themeMode == ThemeMode.light) {
        emit(
          ThemeState(themeData: AppTheme.darkTheme, themeMode: ThemeMode.dark),
        );
      } else {
        emit(
          ThemeState(
            themeData: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
          ),
        );
      }
    });
  }
}
