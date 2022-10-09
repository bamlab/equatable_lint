import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Helper function that returned a stream of custom analysis
/// error fixes
Stream<AnalysisErrorFixes> getCustomAnalysisErrorFixes({
  required Lint lint,
  required ResolvedUnitResult resolvedUnitResult,
  required void Function(DartFileEditBuilder dartFileEditBuilder) buildFileEdit,
  required String sourceChangeMessage,
}) async* {
  final changeBuilder = ChangeBuilder(session: resolvedUnitResult.session);

  final pathToTheCurrentFile =
      resolvedUnitResult.libraryElement.source.fullName;

  await changeBuilder.addDartFileEdit(
    pathToTheCurrentFile,
    buildFileEdit,
  );

  final sourceChange = changeBuilder.sourceChange;
  sourceChange.message = sourceChangeMessage;

  yield AnalysisErrorFixes(
    lint.asAnalysisError(),
    fixes: [
      PrioritizedSourceChange(
        0,
        sourceChange,
      ),
    ],
  );
}
