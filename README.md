# equatable_lint

---

This package used the [custom_lint](https://github.com/invertase/dart_custom_lint) package

---

# Setup

---

- In your `pubspec.yaml`, add these `dev_dependencies` :

```yaml
dev_dependencies:
  custom_lint:
  equatable_lint:
```

- In your `analysis_options.yaml`, add this plugin :

```yaml
analyzer:
  plugins:
    - custom_lint
```

- Run `flutter pub get` or `dart pub get` in your package

- Possibly restart your IDE

---

# Setup CI

---

`flutter analyse` or `dart analyse` don't use this custom rule when checking your code

If you want to analyse your code with this rule in your CI, add a step that run `flutter pub run custom_lint` or `dart run custom_lint`

---

## 👉 About Bam

We are a 100 people company developing and designing multiplatform applications with [React Native](https://www.bam.tech/expertise/react-native) and [Flutter](https://www.bam.tech/expertise/flutter) using the Lean & Agile methodology. To get more information on the solutions that would suit your needs, feel free to get in touch by [email](mailto://contact@bam.tech) or through [contact form](https://www.bam.tech/contact)!

We will always answer you with pleasure 😁
