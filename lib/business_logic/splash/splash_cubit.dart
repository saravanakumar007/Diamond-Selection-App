import 'package:diamond_selection_app/business_logic/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitialState());

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 1));
    emit(SplashLoadingState());
    await Future.delayed(Duration(seconds: 2));
    emit(SplashSucessState());
  }
}
