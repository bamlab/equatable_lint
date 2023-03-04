import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';

import '../constants/equatable_props_field_name.dart';

/// Equatable props fields details parsed from equatable props node
class EquatablePropsExpressionDetails {
  /// [EquatablePropsExpressionDetails] constructor
  const EquatablePropsExpressionDetails({
    required this.initialPart,
    required this.lastPart,
    required this.offset,
    required this.length,
    required this.fieldsNames,
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
  if (closeArrayBrackIndex == equatablePropsExpression.length - 1) {
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

/// Extension to get equatable props node and details
extension EquatablePopsClassMember on ClassDeclaration {
  /// equatable props node getter
  ClassMember? get equatablePropsClassMember {
    final equatablePropsClassMember = members.firstWhereOrNull(
      (fieldElement) =>
          fieldElement.toString().contains('$equatablePropsFieldName ') ||
          fieldElement.toString().contains('$equatablePropsFieldName;'),
    );

    return equatablePropsClassMember;
  }

  /// equatable props details getter
  EquatablePropsExpressionDetails? get equatablePropsExpressionDetails {
    final equatablePropsClassMember = this.equatablePropsClassMember;
    if (equatablePropsClassMember == null) {
      return null;
    }

    final equatablePropsExpressionInitialPart =
        _getEquatablePropsExpressionInitialPart(
      equatablePropsClassMember.toString(),
    );

    if (equatablePropsExpressionInitialPart == null) {
      return null;
    }

    final equatablePropsExpressionLastPart =
        _getEquatablePropsExpressionLastPart(
      equatablePropsClassMember.toString(),
    );

    return EquatablePropsExpressionDetails(
      initialPart: equatablePropsExpressionInitialPart,
      lastPart: equatablePropsExpressionLastPart,
      offset: equatablePropsClassMember.offset,
      length: equatablePropsClassMember.length,
      fieldsNames: _getFieldsNamesFromPropsExpression(
        equatablePropsClassMember.toString(),
      ),
    );
  }
}
