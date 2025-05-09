import 'package:flutter_bloc/flutter_bloc.dart';
import 'viewer_state.dart';

class ViewerCubit extends Cubit<ViewerState> {
  ViewerCubit() : super(ViewerStateInitial());

  void changeToCropMode() {
    emit(ViewerStateCropper());
  }

  void resetToInitial() {
    emit(ViewerStateInitial());
  }
}