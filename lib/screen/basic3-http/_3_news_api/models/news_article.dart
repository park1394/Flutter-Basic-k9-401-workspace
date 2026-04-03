// 뉴스 기사 단일 모델
// 실제 NewsAPI 응답 기준: author·description·urlToImage·content 는 null 가능
class NewsArticle {
  final String title;        // 기사 제목
  final String? description; // 기사 요약 (null 가능)
  final String url;          // 원문 링크
  final String? imageUrl;    // 썸네일 이미지 (null 가능)
  final String publishedAt;  // 발행 시각 (ISO 8601)
  final String source;       // 출처 (언론사명)
  final String? author;      // 작성자 (null 가능, 여러 명일 수 있음)

  NewsArticle({
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.source,
    this.author,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title:       json['title']       as String? ?? '제목 없음',
      description: json['description'] as String?,        // null 허용
      url:         json['url']         as String? ?? '',
      imageUrl:    json['urlToImage']  as String?,        // null 허용
      publishedAt: json['publishedAt'] as String? ?? '',
      source: (json['source'] as Map<String, dynamic>?)?['name']
      as String? ?? '알 수 없음',
      author: json['author'] as String?,                  // null 허용
    );
  }

  // 날짜 포맷 헬퍼 (ISO8601 -> 읽기 쉬운 형식)
  String get formattedDate {
    if (publishedAt.isEmpty) return '';
    try {
      final dt = DateTime.parse(publishedAt).toLocal();
      return '${dt.year}.'
          '${dt.month.toString().padLeft(2, '0')}.'
          '${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return publishedAt;
    }
  }

  // 작성자 이름 요약 (여러 명이면 첫 번째만 표시)
  String? get shortAuthor {
    if (author == null || author!.isEmpty) return null;
    final first = author!.split(',').first.trim();
    return first.length > 20 ? '${first.substring(0, 20)}...' : first;
  }
}