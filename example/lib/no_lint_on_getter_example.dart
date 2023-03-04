import 'package:equatable/equatable.dart';

class NoLintOnGetterExample extends Equatable {
  const NoLintOnGetterExample();

  bool get testGetter => false;

  @override
  List<Object?> get props => [];
}
