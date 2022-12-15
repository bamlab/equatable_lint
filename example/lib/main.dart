// ignore_for_file: avoid_field_initializers_in_const_classes, overridden_fields
import 'package:equatable/equatable.dart';

class FieldNotInPropsExample extends Equatable {
  const FieldNotInPropsExample({this.field, this.field2});

  // A lint will appear here because field is not in not in props
  final String? field;

  // A lint will also appear here because field2 is not in not in props
  final String? field2;

  @override
  List<Object?> get props => [];
}

class NewFieldNotInPropsExample extends FieldNotInPropsExample {
  const NewFieldNotInPropsExample({this.newField});

  // A lint will appear here because extendExampleA is not in not in props
  final String? newField;

  @override
  List<Object?> get props => super.props..addAll([]);
}

class NotCallingSuperForPropsExample extends FieldNotInPropsExample {
  const NotCallingSuperForPropsExample({this.newField});

  // A lint will appear here because newField is not in not in props
  final String? newField;

  @override
  // A lint will appear here because props doesn't call super.props
  // So it doesn't count fields defined in ExampleA class
  List<Object?> get props => [];
}

class NoFieldToAddToPropsExample extends FieldNotInPropsExample {
  const NoFieldToAddToPropsExample();
}

class PropsVariableExample extends Equatable {
  PropsVariableExample({this.field});

  // A lint will appear here because field is not in not in props
  final String? field;

  @override
  late final List<Object?> props = [];
}

class AddOnlyNewFieldToSuperPropsVariableExample extends PropsVariableExample {
  AddOnlyNewFieldToSuperPropsVariableExample({this.newField});

  // A lint will appear here because newField is not in not in props
  final String? newField;

  @override
  late final List<Object?> props = super.props..addAll([]);
}

abstract class AbstractClassWithNoFields extends Equatable {
  const AbstractClassWithNoFields();
}

// A lint will appear here because NoPropsOverrideExample does not override props field
class NoPropsOverrideExample extends AbstractClassWithNoFields {
  const NoPropsOverrideExample({this.field});

  final String? field;
}

abstract class AbstractClassWithAllFieldsInProps extends Equatable {
  const AbstractClassWithAllFieldsInProps({this.abstractField});

  final String? abstractField;

  @override
  List<Object?> get props => [abstractField];
}

// A lint will appear here because AddOnlyNewPropToSuperPropsExample does not override props field
// It will ony add extendExampleD to props since testGetter is a getter and testStatic is static
class AddOnlyNewPropToSuperPropsExample
    extends AbstractClassWithAllFieldsInProps {
  const AddOnlyNewPropToSuperPropsExample({this.newField});

  final String? newField;

  bool get testGetter => false;

  static const testStatic = false;
}

class NoLintOnGetterExample extends Equatable {
  const NoLintOnGetterExample();

  bool get testGetter => false;

  @override
  List<Object?> get props => [];
}

class NoLintOnStaticVariableExample extends Equatable {
  const NoLintOnStaticVariableExample();

  static const testStatic = false;

  @override
  List<Object?> get props => [];
}

class IgnoreOnePropExample extends Equatable {
  const IgnoreOnePropExample({this.ignoredField, this.nonIgnoredField});

  // ignore: add_field_to_equatable_props
  final String? ignoredField;

  final String? nonIgnoredField;

  @override
  List<Object?> get props => [];
}

class ReturnInPropExample extends Equatable {
  const ReturnInPropExample({this.field});

  final String? field;

  @override
  // ignore: prefer_expression_function_bodies
  List<Object?> get props {
    return [];
  }
}

class AddOnlyNewFieldToSuperPropsReturnExample extends ReturnInPropExample {
  AddOnlyNewFieldToSuperPropsReturnExample({this.newField});

  // A lint will appear here because newField is not in not in props
  final String? newField;

  @override
  late final List<Object?> props = super.props..addAll([]);
}
