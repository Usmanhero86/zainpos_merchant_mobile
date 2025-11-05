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
      totalCount: json['total_count'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 25,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'page': page,
      'limit': limit,
    };
  }
}
