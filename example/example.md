In your `pubspec.yaml`, add thes lines to your dev dependencies

```yaml
dev_dependencies:
  custom_lint: ^0.0.12
  equatable_lint:
    path: ^0.1.0
```

In your `analysis_options.yaml`, add thes lines to your analyzer

```yaml
analyzer:
  plugins:
    - custom_lint
```
