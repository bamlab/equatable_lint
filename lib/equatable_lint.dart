import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/always_call_super_props_when_overriding_equatable_props/always_call_super_props_when_overriding_equatable_props.dart';
import 'src/lints/missing_field_in_equatable_props/missing_field_in_equatable_props.dart';

/// Entry point for the Equatable lint plugin
EquatableLint createPlugin() => EquatableLint();

/// Equatable lint plugin base class
class EquatableLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const MissingFieldInEquatableProps(),
        const AlwaysCallSuperPropsWhenOverridingEquatableProps(),
      ];
}
