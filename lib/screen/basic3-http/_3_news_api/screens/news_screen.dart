import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsArticle>> _newsFuture;
  String _selectedCategory = 'general';

  // 카테고리 목록 (country=us 기준 동작 확인)
  static const List<Map<String, String>> _categories = [
    {'key': 'general',       'label': '전체'},
    {'key': 'technology',    'label': '기술'},
    {'key': 'business',      'label': '비즈니스'},
    {'key': 'sports',        'label': '스포츠'},
    {'key': 'entertainment', 'label': '연예'},
    {'key': 'health',        'label': '건강'},
    {'key': 'science',       'label': '과학'},
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    setState(() {
      _newsFuture = NewsService.fetchTopHeadlines(
        country: 'us',               // ⚠️ kr은 결과 없음 → us 권장
        category: _selectedCategory,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 최신 뉴스'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNews),
        ],
      ),
      body: Column(
        children: [
          // ── 카테고리 칩 ──────────────────────────────────
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat['key']!);
                      _loadNews();
                    },
                  ),
                );
              },
            ),
          ),

          // ── 뉴스 리스트 ───────────────────────────────────
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                // 로딩 중
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 오류
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text('오류: ${snapshot.error}',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadNews,
                          child: const Text('재시도'),
                        ),
                      ],
                    ),
                  );
                }
                // 빈 데이터
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      '뉴스가 없습니다.\n카테고리를 바꾸거나 country 코드를 확인하세요.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final articles = snapshot.data!;
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          // url_launcher 패키지로 교체하면 실제 브라우저 열기 가능
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(article.url),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── 썸네일 이미지 (null 이면 아이콘 표시) ──
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: article.imageUrl != null
                                  ? Image.network(
                                article.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _placeholderIcon(),
                              )
                                  : _placeholderIcon(),
                            ),

                            // ── 텍스트 영역 ──────────────────────────
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    // 출처 + 날짜
                                    Row(
                                      children: [
                                        Text(
                                          article.source,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          article.formattedDate,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // 제목
                                    Text(
                                      article.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),

                                    // 요약 (null 이면 생략)
                                    if (article.description != null)
                                      Text(
                                        article.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),

                                    // 작성자 (null 이면 생략)
                                    if (article.shortAuthor != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '✍️ ${article.shortAuthor}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 이미지 없을 때 회색 플레이스홀더
  Widget _placeholderIcon() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.article_outlined, color: Colors.grey, size: 36),
      ),
    );
  }
}