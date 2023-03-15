import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../../missing_field_in_equatable_props/helpers/convert_fields_names_to_single_string.dart';
import '../helpers/add_equatable_super_class_declaration_listener.dart';

/// DartFix to always call super props when overriding equatable props
class CallSuperInOverridedEquatableProps extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addEquatableSuperClassDeclaration(
      ({
        required classNode,
        required equatablePropsClassMember,
        required equatablePropsExpressionDetails,
      }) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'call super in overrided equatable props',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((dartFileEditBuilder) {
          dartFileEditBuilder.addSimpleReplacement(
            SourceRange(
              equatablePropsExpressionDetails.offset,
              equatablePropsExpressionDetails.length,
            ),
            '${equatablePropsExpressionDetails.initialPart}super.props..addAll(${convertFieldsNamesToSingleString(
              equatablePropsExpressionDetails.fieldsNames,
            )})${equatablePropsExpressionDetails.lastPart}',
          );
        });
      },
      optionnalPreCheck: (classNode) {
        if (!classNode.sourceRange.intersects(analysisError.sourceRange)) {
          return false;
        }
        return true;
      },
    );
  }
}
