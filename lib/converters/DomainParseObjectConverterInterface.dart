import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

abstract class DomainParseObjectConverterInterface<T> {

  abstract String _tableName;
  abstract String _className;

  ParseObject domainToNewParseObject(T t);
  T parseObjectToDomain(ParseObject po);

  /// parseObjectToDomainWithOnlyId returns DomainModel and written to be used by the model referring to the DomainModel objectId
  T parseObjectToDomainWithOnlyId(ParseObject po);
  Map domainToPointerParseObject(T t);
  //void domainToUpdateParseObject(ParseObject po, T t);
  //void domainToUpdateParseObject(T t);

}
