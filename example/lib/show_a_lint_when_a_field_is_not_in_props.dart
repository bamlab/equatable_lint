import 'package:equatable/equatable.dart';

class FieldNotInPropsExample extends Equatable {
  const FieldNotInPropsExample({this.field});

  // A lint will appear here because field is not in not in props
  final String? field;

  @override
  List<Object?> get props => [];
}

class NoFieldToAddToPropsExample extends FieldNotInPropsExample {
  const NoFieldToAddToPropsExample();
}

class OtherFieldToAddToPropsExample extends FieldNotInPropsExample {
  const OtherFieldToAddToPropsExample({this.newField});

  final String? newField;

  @override
  List<Object?> get props => super.props..addAll([]);
}
