import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:equatable/equatable.dart';

import '../helpers/convert_fields_names_to_single_string.dart';
import '../helpers/get_ast_node_from_element.dart';
import '../helpers/get_custom_analysis_error_fixes.dart';

/// Custom Lint rule to create [Equatable] props when
/// there is fields defined in the class
Lint? getCreateEquatablePropsLint({
  required ResolvedUnitResult resolvedUnitResult,
  required ClassElement equatableElement,
  required List<FieldElement> fields,
  required bool hasOverrideEquatablePropsInSuperClass,
}) {
  if (fields.isNotEmpty) {
    final equatableDeclaration =
        getAstNodeFromElement(equatableElement) as ClassDeclaration?;

    if (equatableDeclaration != null) {
      return Lint(
        code: 'create_equatable_props_with_every_fields',
        message: 'Create equatable props with every fields',
        location: resolvedUnitResult.lintLocationFromOffset(
          equatableDeclaration.name2.offset,
          length: equatableDeclaration.name2.length,
        ),
        getAnalysisErrorFixes: (lint) => getCustomAnalysisErrorFixes(
          lint: lint,
          resolvedUnitResult: resolvedUnitResult,
          buildFileEdit: (dartFileEditBuilder) {
            dartFileEditBuilder.addSimpleReplacement(
              SourceRange(
                equatableDeclaration.offset + equatableDeclaration.length - 2,
                1,
              ),
              _getEquatablePropsOverrideWithFields(
                fieldsNames: fields.map((field) => field.name).toList(),
                hasOverrideEquatablePropsInSuperClass:
                    hasOverrideEquatablePropsInSuperClass,
              ),
            );
          },
          sourceChangeMessage: 'Create equatable props with every fields',
        ),
      );
    }
  }
  return null;
}

String _getEquatablePropsOverrideWithFields({
  required List<String> fieldsNames,
  required bool hasOverrideEquatablePropsInSuperClass,
}) {
  const override = '\n\n\t@override';
  const equatablePropsGetterDefinition = '\n\tList<Object?> get props => ';

  final fieldsNamesPrefix =
      hasOverrideEquatablePropsInSuperClass ? 'super.props..addAll(' : '';
  final fieldsNamesSuffix = hasOverrideEquatablePropsInSuperClass ? ')' : '';

  const end = ';\n';

  final fieldsNamesSingleString = convertFieldsNamesToSingleString(fieldsNames);

  return override +
      equatablePropsGetterDefinition +
      fieldsNamesPrefix +
      fieldsNamesSingleString +
      fieldsNamesSuffix +
      end;
}
