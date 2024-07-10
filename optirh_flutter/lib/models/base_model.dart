/// BaseModel class, base class for application models
abstract class BaseModel {
  final int id;

  /// Creates a new BaseModel
  BaseModel(this.id);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseModel &&
        runtimeType == other.runtimeType &&
        id == other.id;
  }

  @override
  int get hashCode => id;
}