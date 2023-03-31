part of query_stack;

class QueryKey implements IEquatable {
  QueryKey(List<dynamic> key) : _key = key.map((value) => value.toString()).join("|");

  final String _key;

  @override
  String toString() => _key;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is QueryKey && other._key == _key);

  @override
  int get hashCode => _key.hashCode;
}
