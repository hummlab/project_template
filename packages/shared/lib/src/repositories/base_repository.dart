/// Exception thrown by repository operations
/// 
/// This exception is used to wrap and standardize errors that occur
/// during repository operations.
class RepositoryException implements Exception {
  /// The error message
  final String message;
  
  /// The original error that caused this exception
  final dynamic originalError;
  
  /// Creates a new RepositoryException
  /// 
  /// [message] - Human-readable error message
  /// [originalError] - The original error that caused this exception
  const RepositoryException(this.message, [this.originalError]);
  
  @override
  String toString() => 'RepositoryException: $message';
}

/// Base repository interface
/// 
/// This abstract class defines common repository operations
/// that can be implemented by specific repository classes.
abstract class BaseRepository<T, ID> {
  /// Retrieves an entity by its unique identifier
  /// 
  /// [id] - The unique identifier of the entity
  /// Returns the entity if found, null otherwise
  /// Throws [RepositoryException] if the operation fails
  Future<T?> getById(ID id);
  
  /// Retrieves all entities
  /// 
  /// Returns a list of all entities
  /// Throws [RepositoryException] if the operation fails
  Future<List<T>> getAll();
  
  /// Creates a new entity
  /// 
  /// [entity] - The entity to create
  /// Returns the created entity with updated fields (e.g., ID, timestamps)
  /// Throws [RepositoryException] if the operation fails
  Future<T> create(T entity);
  
  /// Updates an existing entity
  /// 
  /// [entity] - The entity to update
  /// Returns the updated entity
  /// Throws [RepositoryException] if the operation fails
  Future<T> update(T entity);
  
  /// Deletes an entity by its unique identifier
  /// 
  /// [id] - The unique identifier of the entity to delete
  /// Throws [RepositoryException] if the operation fails
  Future<void> delete(ID id);
  
  /// Checks if an entity exists by its unique identifier
  /// 
  /// [id] - The unique identifier of the entity
  /// Returns true if the entity exists, false otherwise
  /// Throws [RepositoryException] if the operation fails
  Future<bool> exists(ID id);
}
