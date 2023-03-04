import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../helpers/get_equatable_props_expression_infos.dart';
import '../../helpers/get_has_override_equatable_props_in_super_class.dart';

/// Lint to make props override call super.props if needed
class AlwaysCallSuperPropsWhenOverridingEquatableProps extends DartLintRule {
  /// [AlwaysCallSuperPropsWhenOverridingEquatableProps] constructor
  const AlwaysCallSuperPropsWhenOverridingEquatableProps() : super(code: _code);

  static const _code = LintCode(
    name: 'always_call_super_props_when_overriding_equatable_props',
    problemMessage:
        'Dont forget to call super.props when overriding equtable props',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((classNode) {
      final classSuperTypeElement =
          classNode.declaredElement!.supertype?.element;

      if (classSuperTypeElement == null) {
        return;
      }

      final hasOverrideEquatablePropsInSuperClass =
          getHasOverrideEquatablePropsInSuperClass(classSuperTypeElement);

      if (!hasOverrideEquatablePropsInSuperClass) {
        return;
      }

      final equatablePropsClassMember = classNode.equatablePropsClassMember;

      if (equatablePropsClassMember == null) {
        return;
      }

      final doesPropsCallSuper =
          equatablePropsClassMember.toString().contains('super.props');

      if (doesPropsCallSuper) {
        return;
      }

      reporter.reportErrorForNode(_code, equatablePropsClassMember);
    });
  }

  @override
  List<Fix> getFixes() => [];
}
