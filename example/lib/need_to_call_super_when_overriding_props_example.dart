import 'package:equatable/equatable.dart';

class BaseEquatableClass extends Equatable {
  const BaseEquatableClass({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}

class NeedToCallSuperWhenOverridingPropsExample extends BaseEquatableClass {
  const NeedToCallSuperWhenOverridingPropsExample({this.newField});

  final String? newField;

  @override
  // A lint will appear here because props doesn't call super.props
  // So it doesn't count fields defined in NewFieldNotInPropsExample class
  List<Object?> get props => [newField];
}
