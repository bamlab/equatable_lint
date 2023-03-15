import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../helpers/add_equatable_class_field_declaration_listener.dart';
import '../helpers/convert_fields_names_to_single_string.dart';

/// DartFix to add every missing fields in equatable props
class AddEveryFieldsToEquatableProps extends DartFix {
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
        if (equatablePropsExpressionDetails == null) {
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
          message: 'add every missing fields to equatable props',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              equatablePropsExpressionDetails.offset,
              equatablePropsExpressionDetails.length,
            ),
            equatablePropsExpressionDetails.initialPart +
                convertFieldsNamesToSingleString(
                  watchableFields.map((field) => field.displayName).toList(),
                ) +
                equatablePropsExpressionDetails.lastPart,
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
