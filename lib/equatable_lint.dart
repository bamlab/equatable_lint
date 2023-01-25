import 'package:analyzer/dart/analysis/results.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable/equatable.dart';
import 'package:source_gen/source_gen.dart';

import 'const.dart';
import 'helpers/get_equatable_props_expression_infos.dart';
import 'helpers/get_has_override_equatable_props_in_super_class.dart';
import 'rules/get_add_field_to_equatable_props_lint.dart';
import 'rules/get_create_equatable_props_lint.dart';
import 'rules/get_props_need_to_call_super_lint.dart';

/// Entry point for the Equatable lint plugin
EquatableLint createPlugin() => EquatableLint();

/// Equatable lint plugin base class
class EquatableLint extends PluginBase {
  @override
  Stream<Lint> getLints(ResolvedUnitResult resolvedUnitResult) async* {
    final classElements = resolvedUnitResult.unit.declaredElement?.classes;

    if (classElements == null) {
      return;
    }

    const typeChecker = TypeChecker.fromRuntime(Equatable);

    final equatableElements = classElements.where(
      (classElement) {
        final type = classElement.thisType;
        final checkType = typeChecker.isAssignableFromType(type);
        return checkType;
      },
    ).toList();

    for (final equatableElement in equatableElements) {
      final equatablePropsExpressionDetails =
          getEquatablePropsExpressionDetails(equatableElement);
      final fields = equatableElement.fields
          .where(
            (fieldElement) => fieldElement.name != equatablePropsName,
          )
          .where(
            (fieldElement) => !fieldElement.isSynthetic,
          ) // Remove getter/Setter
          .where((fieldElement) => !fieldElement.isStatic)
          .toList();

      if (equatablePropsExpressionDetails == null) {
        final equatableClassSuperType = equatableElement.supertype;
        if (equatableClassSuperType != null) {
          final hasOverrideEquatablePropsInSuperClass =
              getHasOverrideEquatablePropsInSuperClass(
            equatableClassSuperType.element,
          );

          final createEquatablePropsLint = getCreateEquatablePropsLint(
            resolvedUnitResult: resolvedUnitResult,
            equatableElement: equatableElement,
            fields: fields,
            hasOverrideEquatablePropsInSuperClass:
                hasOverrideEquatablePropsInSuperClass,
          );

          if (createEquatablePropsLint != null) {
            yield createEquatablePropsLint;
          }
        }
      } else {
        final addFieldToEquatablePropsLints = getAddFieldToEquatablePropsLint(
          resolvedUnitResult: resolvedUnitResult,
          equatablePropsExpressionDetails: equatablePropsExpressionDetails,
          fields: fields,
        );

        if (addFieldToEquatablePropsLints != null) {
          for (final addFieldToEquatablePropsLint
              in addFieldToEquatablePropsLints) {
            yield addFieldToEquatablePropsLint;
          }
        }

        final equatableClassSuperType = equatableElement.supertype;
        if (equatableClassSuperType != null) {
          final hasOverrideEquatablePropsInSuperClass =
              getHasOverrideEquatablePropsInSuperClass(
            equatableClassSuperType.element,
          );

          final propsNeedToCallSuperLint = getPropsNeedToCallSuperLint(
            resolvedUnitResult: resolvedUnitResult,
            equatablePropsExpressionDetails: equatablePropsExpressionDetails,
            hasOverrideEquatablePropsInSuperClass:
                hasOverrideEquatablePropsInSuperClass,
          );

          if (propsNeedToCallSuperLint != null) {
            yield propsNeedToCallSuperLint;
          }
        }
      }
    }
  }
}
