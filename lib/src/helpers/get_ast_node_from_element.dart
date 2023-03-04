import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

/// Helper function to get AstNode from Element one
AstNode? getAstNodeFromElement(Element element) {
  final session = element.session;
  final parsedLibResult = session?.getParsedLibraryByElement(element.library!)
      as ParsedLibraryResult?;
  final elementDeclarationResult =
      parsedLibResult?.getElementDeclaration(element);
  return elementDeclarationResult?.node;
}
