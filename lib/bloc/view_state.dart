part of 'view_bloc.dart';

abstract class ViewState extends Equatable {
  final bool isViewNormal;
  const ViewState({required this.isViewNormal});

  @override
  List<Object> get props => [isViewNormal];
}

class ViewNormal extends ViewState {
  const ViewNormal({required super.isViewNormal});
}

class ViewForOlder extends ViewState {
  const ViewForOlder({required super.isViewNormal});
}
