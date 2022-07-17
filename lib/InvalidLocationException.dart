class InvalidLocationException implements Exception {
  String cause;
  InvalidLocationException(this.cause);

  @override
  String toString() {
    return 'InvalidLocationException{cause: $cause}';
  }
}
