import 'dart:convert';

class EodCardTransactionsResponse {
  final List<dynamic> data;
  final Pagination pagination;

  EodCardTransactionsResponse({
    required this.data,
    required this.pagination,
  });

  factory EodCardTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return EodCardTransactionsResponse(
      data: json['data'] ?? [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  factory EodCardTransactionsResponse.fromRawJson(String str) =>
      EodCardTransactionsResponse.fromJson(json.decode(str));
}

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
}
