import 'package:equatable/equatable.dart';

class IgnoreOnePropExample extends Equatable {
  const IgnoreOnePropExample({this.ignoredField, this.nonIgnoredField});

  // expect_lint: missing_field_in_equatable_props
  final String? ignoredField;

  final String? nonIgnoredField;

  @override
  List<Object?> get props => [];
}
