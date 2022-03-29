import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class DomainToParseObjectConverter<T> {

  ParseObject fromDomain(T t);
  T fromParseObject(ParseObject po);
}
