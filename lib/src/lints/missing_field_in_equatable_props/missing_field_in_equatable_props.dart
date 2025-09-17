import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'fixes/add_every_fields_to_equatable_props.dart';
import 'fixes/add_field_to_equatable_props.dart';
import 'fixes/create_equatable_props_every_fields_in_it.dart';
import 'fixes/create_equatable_props_with_field_in_it.dart';
import 'helpers/add_equatable_class_field_declaration_listener.dart';

/// Lint to add missing fields to equatable props
class MissingFieldInEquatableProps extends DartLintRule {
  /// [MissingFieldInEquatableProps] constructor
  const MissingFieldInEquatableProps() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_field_in_equatable_props',
    problemMessage: 'Every field of your class should be in equatable props',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addEquatableClassFieldDeclaration(({
      required fieldNode,
      required fieldElement,
      required classNode,
      required watchableFields,
      required equatablePropsExpressionDetails,
    }) {
      final equatablePropsFieldsNames =
          equatablePropsExpressionDetails?.fieldsNames;
      final isFieldInEquatableProps =
          equatablePropsFieldsNames?.contains(fieldElement.displayName) ??
              false;
      if (!isFieldInEquatableProps) {
        reporter.reportErrorForNode(_code, fieldNode);
      }
    });
  }

  @override
  List<Fix> getFixes() => [
        AddFieldToEquatableProps(),
        AddEveryFieldsToEquatableProps(),
        CreataEquatablePropsWithFieldInIt(),
        CreataEquatablePropsWithEveryFieldsInIt(),
      ];
}
