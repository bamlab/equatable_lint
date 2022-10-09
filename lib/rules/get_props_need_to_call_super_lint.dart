import 'package:analyzer/dart/analysis/results.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../helpers/get_equatable_props_expression_infos.dart';

/// Lint when you override props field but don't call super.props in it
/// You might compare props without using the superclass fields
Lint? getPropsNeedToCallSuperLint({
  required ResolvedUnitResult resolvedUnitResult,
  required EquatablePropsExpressionDetails equatablePropsExpressionDetails,
  required bool hasOverrideEquatablePropsInSuperClass,
}) {
  if (hasOverrideEquatablePropsInSuperClass) {
    final doesInitialPartContainsSuperPropsCall =
        equatablePropsExpressionDetails.initialPart.contains('super.props');
    final doesLastPartContainsSuperPropsCall =
        equatablePropsExpressionDetails.lastPart.contains('super.props');

    if (!doesInitialPartContainsSuperPropsCall &&
        !doesLastPartContainsSuperPropsCall) {
      return Lint(
        code: 'props_need_to_call_super',
        message:
            'You need to call super.props to include super class fields in comparaison',
        location: resolvedUnitResult.lintLocationFromOffset(
          equatablePropsExpressionDetails.nameOffset,
          length: equatablePropsExpressionDetails.nameLength,
        ),
      );
    }
  }
  return null;
}
