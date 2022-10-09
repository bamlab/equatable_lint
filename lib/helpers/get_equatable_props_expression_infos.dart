import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

import '../const.dart';
import 'get_ast_node_from_element.dart';

/// Useful to linting informations of the props expression
class EquatablePropsExpressionDetails {
  /// [EquatablePropsExpressionDetails] default constructor
  const EquatablePropsExpressionDetails({
    required this.initialPart,
    required this.lastPart,
    required this.offset,
    required this.length,
    required this.fieldsNames,
    required this.nameOffset,
    required this.nameLength,
  });

  /// part before the array of fields of the props expression
  final String initialPart;

  /// part after the array of fields of the props expression
  final String lastPart;

  /// offset to the begining of the props expression
  final int offset;

  /// length of the props expression
  final int length;

  /// list of the fields names contained in the props expression
  final List<String> fieldsNames;

  /// offset to the begining of the props name
  final int nameOffset;

  /// offset to the begining of the props name
  final int nameLength;
}

String? _getEquatablePropsExpressionInitialPart(
  String equatablePropsExpression,
) {
  final openArrayBrackIndex = equatablePropsExpression.indexOf('[');
  if (openArrayBrackIndex == -1) {
    return null;
  }

  return equatablePropsExpression.substring(
    0,
    openArrayBrackIndex,
  )..replaceAll('const', '');
}

String _getEquatablePropsExpressionLastPart(String equatablePropsExpression) {
  final closeArrayBrackIndex = equatablePropsExpression.indexOf(']');
  if (closeArrayBrackIndex == -1) {
    return '';
  }
  if (closeArrayBrackIndex + 1 == equatablePropsExpression.length) {
    return '';
  }

  return equatablePropsExpression.substring(closeArrayBrackIndex + 1);
}

List<String> _getFieldsNamesFromPropsExpression(
  String equatablePropsExpression,
) {
  final firstBracket = equatablePropsExpression.indexOf('[') + 1;
  final lastBracket = equatablePropsExpression.indexOf(']');
  return equatablePropsExpression
      .substring(firstBracket, lastBracket)
      .replaceAll(' ', '')
      .split(',')
    ..removeWhere((fieldName) => fieldName.isEmpty);
}

/// get the expression details of your props getter
EquatablePropsExpressionDetails? getEquatablePropsExpressionDetails(
  ClassElement equatableElement,
) {
  final equatablePropsAccessorElement =
      equatableElement.accessors.firstWhereOrNull(
    (accessor) =>
        accessor.hasOverride &&
        accessor.isGetter &&
        accessor.name == equatablePropsName,
  );
  if (equatablePropsAccessorElement != null) {
    final equatablePropsDeclaration =
        getAstNodeFromElement(equatablePropsAccessorElement)
            as MethodDeclaration?;

    if (equatablePropsDeclaration == null) {
      return null;
    }
    final equatablePropsExpression = equatablePropsDeclaration.body.toString();

    final equatablePropsExpressionInitialPart =
        _getEquatablePropsExpressionInitialPart(equatablePropsExpression);

    if (equatablePropsExpressionInitialPart == null) {
      return null;
    }

    final equatablePropsExpressionLastPart =
        _getEquatablePropsExpressionLastPart(equatablePropsExpression);

    return EquatablePropsExpressionDetails(
      initialPart: equatablePropsExpressionInitialPart,
      lastPart: equatablePropsExpressionLastPart,
      offset: equatablePropsDeclaration.body.offset,
      length: equatablePropsDeclaration.body.length,
      fieldsNames: _getFieldsNamesFromPropsExpression(equatablePropsExpression),
      nameOffset: equatablePropsDeclaration.name2.offset,
      nameLength: equatablePropsDeclaration.name2.length,
    );
  }

  final equatablePropsFieldElement = equatableElement.fields.firstWhereOrNull(
    (field) => field.hasOverride && field.name == equatablePropsName,
  );
  if (equatablePropsFieldElement != null) {
    final equatableGetterDeclaration =
        getAstNodeFromElement(equatablePropsFieldElement)
            as VariableDeclaration?;

    if (equatableGetterDeclaration == null) {
      return null;
    }
    final equatablePropsExpression = equatableGetterDeclaration.toString();

    final equatablePropsExpressionInitialPart =
        _getEquatablePropsExpressionInitialPart(equatablePropsExpression);

    if (equatablePropsExpressionInitialPart == null) {
      return null;
    }

    final equatablePropsExpressionLastPart =
        _getEquatablePropsExpressionLastPart(equatablePropsExpression);

    return EquatablePropsExpressionDetails(
      initialPart: equatablePropsExpressionInitialPart,
      lastPart: equatablePropsExpressionLastPart,
      offset: equatableGetterDeclaration.offset,
      length: equatableGetterDeclaration.length,
      fieldsNames: _getFieldsNamesFromPropsExpression(equatablePropsExpression),
      nameOffset: equatableGetterDeclaration.name2.offset,
      nameLength: equatableGetterDeclaration.name2.length,
    );
  }

  return null;
}
