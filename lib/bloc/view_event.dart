part of 'view_bloc.dart';

abstract class ViewEvent extends Equatable {
  const ViewEvent();

  @override
  List<Object> get props => [];
}

class ChangeView extends ViewEvent{}