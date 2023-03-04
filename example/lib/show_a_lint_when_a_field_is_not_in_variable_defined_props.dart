// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';

class FieldNotInPropsExample extends Equatable {
  FieldNotInPropsExample({this.field});

  // A lint will appear here because field is not in not in props
  final String? field;

  @override
  late final List<Object?> props = [];
}

class NoFieldToAddToPropsExample extends FieldNotInPropsExample {
  NoFieldToAddToPropsExample();
}

class OtherFieldToAddToPropsExample extends FieldNotInPropsExample {
  OtherFieldToAddToPropsExample({this.newField});

  final String? newField;

  @override
  late final List<Object?> props = super.props..addAll([]);
}
