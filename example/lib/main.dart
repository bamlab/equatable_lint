// ignore_for_file: avoid_field_initializers_in_const_classes, overridden_fields
import 'package:equatable/equatable.dart';

class ExampleA extends Equatable {
  const ExampleA({this.exampleA});

  // A lint will appear here because exampleA is not in not in props
  final String? exampleA;

  @override
  List<Object?> get props => [];
}

class ExtendExampleA1 extends ExampleA {
  const ExtendExampleA1({this.extendExampleA});

  // A lint will appear here because extendExampleA is not in not in props
  final String? extendExampleA;

  @override
  List<Object?> get props => super.props..addAll([]);
}

class ExtendExampleA2 extends ExampleA {
  const ExtendExampleA2({this.extendExampleA});

  // A lint will appear here because extendExampleA is not in not in props
  final String? extendExampleA;

  // No lint appear here because this is a getter
  bool get test => false;

  @override
  // A lint will appear here because props doesn't call super.props
  // So it doesn't count fields defined in ExampleA class
  List<Object?> get props => [];
}

class ExtendExampleA3 extends ExampleA {
  const ExtendExampleA3();
}

class ExampleB extends Equatable {
  ExampleB({this.exampleB});

  // A lint will appear here because exampleB is not in not in props
  final String? exampleB;

  @override
  late final List<Object?> props = [];
}

class ExtendExampleB extends ExampleB {
  ExtendExampleB({this.extendExampleB});

  // A lint will appear here because extendExampleB is not in not in props
  final String? extendExampleB;

  @override
  late final List<Object?> props = super.props..addAll([]);
}

abstract class ExampleC extends Equatable {
  const ExampleC();
}

// A lint will appear here because ExtendExampleC does not override props field
class ExtendExampleC extends ExampleC {
  const ExtendExampleC({this.extendExampleC});

  final String? extendExampleC;
}

abstract class ExampleD extends Equatable {
  const ExampleD({this.exampleD});

  final String? exampleD;

  @override
  List<Object?> get props => [exampleD];
}

// A lint will appear here because ExtendExampleD does not override props field
// It will ony add extendExampleD to props since testGetter is a getter and testStatic is static
class ExtendExampleD extends ExampleD {
  const ExtendExampleD({this.extendExampleD});

  final String? extendExampleD;

  bool get testGetter => false;

  static const testStatic = false;
}
