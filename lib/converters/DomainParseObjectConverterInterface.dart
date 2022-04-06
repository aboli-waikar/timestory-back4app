import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class DomainParseObjectConverterInterface<T> {

  abstract String _tableName;
  abstract String _className;

  ParseObject domainToNewParseObject(T t);
  T parseObjectToDomain(ParseObject po);
  T parseReference(ParseObject po);
  Map domainToPointerParseObject(T t);
  void updateParseObject(ParseObject po, T t);
}
