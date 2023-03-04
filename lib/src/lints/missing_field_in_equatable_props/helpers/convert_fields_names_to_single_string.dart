/// Take every fields names and concat them in a single string
String convertFieldsNamesToSingleString(List<String> fieldsNames) {
  final fieldsString = fieldsNames.fold(
    '[',
    (previousValue, fieldName) => '$previousValue $fieldName,',
  );
  return '$fieldsString ]';
}
