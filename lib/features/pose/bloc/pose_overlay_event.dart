import 'package:equatable/equatable.dart';
import '../domain/entities/pose_entity.dart';

abstract class PoseOverlayEvent extends Equatable {
  const PoseOverlayEvent();

  @override
  List<Object?> get props => [];
}

class PoseOverlayLoaded extends PoseOverlayEvent {
  final String category;
  const PoseOverlayLoaded({this.category = 'All'});

  @override
  List<Object?> get props => [category];
}

class PoseSelected extends PoseOverlayEvent {
  final PoseEntity pose;
  const PoseSelected(this.pose);

  @override
  List<Object?> get props => [pose];
}

class PoseOpacityChanged extends PoseOverlayEvent {
  final double opacity;
  const PoseOpacityChanged(this.opacity);

  @override
  List<Object?> get props => [opacity];
}

class PoseOverlayVisibilityToggled extends PoseOverlayEvent {
  const PoseOverlayVisibilityToggled();
}
