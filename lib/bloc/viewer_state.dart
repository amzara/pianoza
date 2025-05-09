import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ViewerState {}

class ViewerStateInitial extends ViewerState {
}

class ViewerStateCropper extends ViewerState{


}

//the sidebar can just listen to the viewerstate
//if in normal mode = button will be "crop"
//if in crop mode = button will be "done"




//only 1 initial state as we're not loading anything
