import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../../helpers/get_has_override_equatable_props_in_super_class.dart';
import '../helpers/add_equatable_class_field_declaration_listener.dart';
import '../helpers/get_equatable_props_override_with_fields.dart';

/// DartFix to create missing equatable props with every fields in it
class CreataEquatablePropsWithEveryFieldsInIt extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addEquatableClassFieldDeclaration(
      ({
        required fieldNode,
        required fieldElement,
        required classNode,
        required watchableFields,
        required equatablePropsExpressionDetails,
      }) {
        if (equatablePropsExpressionDetails != null) {
          return;
        }

        final classSuperTypeElement =
            classNode.declaredElement!.supertype?.element;

        if (classSuperTypeElement == null) {
          return;
        }

        final fieldsToAdd =
            watchableFields.map((field) => field.displayName).toList();

        if (fieldsToAdd.equals([fieldElement.displayName])) {
          return;
        }

        final changeBuilder = reporter.createChangeBuilder(
          message: 'create equatable props override with every fields in it',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              classNode.offset + classNode.length - 2,
              1,
            ),
            getEquatablePropsOverrideWithFields(
              fieldsNames:
                  watchableFields.map((field) => field.displayName).toList(),
              hasOverrideEquatablePropsInSuperClass:
                  getHasOverrideEquatablePropsInSuperClass(
                classSuperTypeElement,
              ),
            ),
          );
        });
      },
      optionnalPreCheck: (fieldNode) {
        if (!fieldNode.sourceRange.intersects(analysisError.sourceRange)) {
          return false;
        }
        return true;
      },
    );
  }
}
