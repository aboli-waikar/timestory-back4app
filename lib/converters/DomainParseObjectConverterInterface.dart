import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class DomainParseObjectConverterInterface<T> {

  ParseObject domainToNewParseObject(T t);
  T parseObjectToDomain(ParseObject po);
  T parseReference(ParseObject po);
  void updateParseObject(ParseObject po, T t);
}
