// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';

class FieldNotInPropsExample extends Equatable {
  FieldNotInPropsExample({this.field, this.field2});

  // A lint will appear because these fields are not in not in props

  final String? field;

  final String? field2;

  @override
  late final List<Object?> props = [];
}

class NoFieldToAddToPropsExample extends FieldNotInPropsExample {
  NoFieldToAddToPropsExample();
}

class OtherFieldToAddToPropsExample extends FieldNotInPropsExample {
  OtherFieldToAddToPropsExample({this.newField, this.newField2});

  // A lint will appear because these fields are not in not in props

  final String? newField;

  final String? newField2;

  @override
  late final List<Object?> props = super.props..addAll([]);
}
