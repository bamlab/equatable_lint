// ignore_for_file: avoid_field_initializers_in_const_classes, overridden_fields
import 'package:equatable/equatable.dart';

class ExampleA extends Equatable {
  const ExampleA({this.exampleA});

  final String? exampleA;

  @override
  List<Object?> get props => [];
}

class ExtendExampleA1 extends ExampleA {
  const ExtendExampleA1({this.extendExampleA});

  final String? extendExampleA;

  @override
  List<Object?> get props => super.props..addAll([]);
}

class ExtendExampleA2 extends ExampleA {
  const ExtendExampleA2({this.extendExampleA});

  final String? extendExampleA;

  bool get test => false;

  @override
  List<Object?> get props => [];
}

class ExtendExampleA3 extends ExampleA {
  const ExtendExampleA3();
}

class ExampleB extends Equatable {
  ExampleB({this.exampleB});

  final String? exampleB;

  @override
  late final List<Object?> props = [];
}

class ExtendExampleB extends ExampleB {
  ExtendExampleB({this.extendExampleB});

  final String? extendExampleB;

  @override
  late final List<Object?> props = super.props..addAll([]);
}

abstract class ExampleC extends Equatable {
  const ExampleC();
}

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

class ExtendExampleD extends ExampleD {
  const ExtendExampleD({this.extendExampleD});

  final String? extendExampleD;

  bool get test => false;
}
