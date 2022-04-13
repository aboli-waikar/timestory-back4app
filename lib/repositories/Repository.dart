import 'package:timestory_back4app/model/Domain.dart';

abstract class Repository<T extends Domain> {

  abstract String _tableName;

  static const String _pkColumn = 'objectId';

  Future<List<T>> getAll();
  Future<T> getById(String objectId);
  void create(T t);
  void update(T t);
  delete(T t);

}