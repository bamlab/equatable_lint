import 'package:equatable/equatable.dart';

class NoLintOnStaticVariableExample extends Equatable {
  const NoLintOnStaticVariableExample();

  static const testStatic = false;

  @override
  List<Object?> get props => [];
}
