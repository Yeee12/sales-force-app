enum VisitStatus {
  pending('Pending'),
  completed('Completed'),
  cancelled('Cancelled');

  const VisitStatus(this.value);
  final String value;

  static VisitStatus fromString(String value) {
    return VisitStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => VisitStatus.pending,
    );
  }
}
