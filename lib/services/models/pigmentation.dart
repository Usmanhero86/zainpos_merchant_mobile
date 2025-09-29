class Pagination {
  final int totalCount;
  final int page;
  final int limit;

  Pagination({
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['total_count'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}
