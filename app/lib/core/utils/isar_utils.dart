/// Simple hash function for IDs
int fastHash(String string) {
  // Use built-in hashCode which is platform optimized
  // This is sufficient since we aren't using cross-device Isar sync yet
  return string.hashCode;
}
