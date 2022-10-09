import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable/equatable.dart';

import '../helpers/convert_fields_names_to_single_string.dart';
import '../helpers/get_custom_analysis_error_fixes.dart';
import '../helpers/get_equatable_props_expression_infos.dart';

/// Custom Lint rule to check if a field from an [Equatable] class
/// is present in the "props" getter
Lint? getAddFieldToEquatablePropsLint({
  required ResolvedUnitResult resolvedUnitResult,
  required EquatablePropsExpressionDetails equatablePropsExpressionDetails,
  required List<FieldElement> fields,
}) {
  for (final field in fields) {
    final isFieldInEquatableProps =
        equatablePropsExpressionDetails.fieldsNames.contains(field.name);

    if (!isFieldInEquatableProps) {
      final startLintOffset = field.nameOffset;
      final lintLength = field.nameLength;

      return Lint(
        code: 'add_field_to_equatable_props',
        message: 'Add this field to the equatable props override',
        location: resolvedUnitResult.lintLocationFromOffset(
          startLintOffset,
          length: lintLength,
        ),
        getAnalysisErrorFixes: (lint) => getCustomAnalysisErrorFixes(
          lint: lint,
          resolvedUnitResult: resolvedUnitResult,
          buildFileEdit: (dartFileEditBuilder) {
            dartFileEditBuilder.addSimpleReplacement(
              SourceRange(
                equatablePropsExpressionDetails.offset,
                equatablePropsExpressionDetails.length,
              ),
              equatablePropsExpressionDetails.initialPart +
                  convertFieldsNamesToSingleString(
                    [
                      ...equatablePropsExpressionDetails.fieldsNames,
                      field.name
                    ],
                  ) +
                  equatablePropsExpressionDetails.lastPart,
            );
          },
          sourceChangeMessage: 'Add field ${field.name} to equatable props',
        ),
      );
    }
  }
  return null;
}
