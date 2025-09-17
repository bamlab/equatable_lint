import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'fixes/call_super_in_overrided_equatable_props.dart';
import 'helpers/add_equatable_super_class_declaration_listener.dart';

/// Lint to make props override call super.props if needed
class AlwaysCallSuperPropsWhenOverridingEquatableProps extends DartLintRule {
  /// [AlwaysCallSuperPropsWhenOverridingEquatableProps] constructor
  const AlwaysCallSuperPropsWhenOverridingEquatableProps() : super(code: _code);

  static const _code = LintCode(
    name: 'always_call_super_props_when_overriding_equatable_props',
    problemMessage:
        'Dont forget to call super.props when overriding equatable props',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addEquatableSuperClassDeclaration(({
      required classNode,
      required equatablePropsClassMember,
      required equatablePropsExpressionDetails,
    }) {
      reporter.reportErrorForNode(_code, equatablePropsClassMember);
    });
  }

  @override
  List<Fix> getFixes() => [
        CallSuperInOverridedEquatableProps(),
      ];
}
