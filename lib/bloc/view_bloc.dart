import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view_event.dart';
part 'view_state.dart';

class ViewBloc extends Bloc<ViewEvent, ViewState> {
  ViewBloc() : super(const ViewNormal(isViewNormal: true)) {
    on<ViewEvent>((event, emit) {});
    on<ChangeView>(_onChangeView);
  }
  _onChangeView(ChangeView event, Emitter<ViewState> emit) {
    if (state is ViewNormal) {
      emit(const ViewForOlder(isViewNormal: false));
    } else {
      emit(const ViewNormal(isViewNormal: true));
    }
  }
}
