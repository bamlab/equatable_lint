import 'package:analyzer/dart/ast/ast.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../../helpers/get_equatable_props_expression_infos.dart';
import '../../../helpers/get_has_override_equatable_props_in_super_class.dart';

/// Extension to add a specific listener for equatable super class
extension AddEquatableSuperClassDeclarationListener on LintRuleNodeRegistry {
  /// Getter to add a specific listener for equatable super class
  void addEquatableSuperClassDeclaration(
    void Function({
      required ClassDeclaration classNode,
      required ClassMember equatablePropsClassMember,
      required EquatablePropsExpressionDetails equatablePropsExpressionDetails,
    }) listener, {
    bool Function(ClassDeclaration)? optionnalPreCheck,
  }) {
    addClassDeclaration((classNode) {
      if (optionnalPreCheck != null) {
        final canContinue = optionnalPreCheck(classNode);
        if (!canContinue) {
          return;
        }
      }

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

      final equatablePropsExpressionDetails =
          classNode.equatablePropsExpressionDetails;

      if (equatablePropsExpressionDetails == null) {
        return;
      }

      listener(
        classNode: classNode,
        equatablePropsClassMember: equatablePropsClassMember,
        equatablePropsExpressionDetails: equatablePropsExpressionDetails,
      );
    });
  }
}
