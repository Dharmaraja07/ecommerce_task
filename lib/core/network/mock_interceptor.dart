import 'package:dio/dio.dart';
import 'dart:convert';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (options.path.contains('/search')) {
      final query = options.queryParameters['q'] ?? '';
      handler.resolve(
        Response(
          requestOptions: options,
          data: _getSearchMockData(query),
          statusCode: 200,
        ),
      );
      return;
    }

    if (options.path.contains('/product')) {
      handler.resolve(
        Response(
          requestOptions: options,
          data: _getProductMockData(),
          statusCode: 200,
        ),
      );
      return;
    }

    super.onRequest(options, handler);
  }

  Map<String, dynamic> _getSearchMockData(String query) {
    return {
      "results": [
        {
          "id": "1",
          "name": "Luxury Matte Lipstick",
          "brand": "Sephora Collection",
          "price": 45.00,
          "image": "https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&q=80&w=400",
          "rating": 4.5,
          "reviews": 120
        },
        {
          "id": "2",
          "name": "Hydrating Face Serum",
          "brand": "Glow Recipe",
          "price": 32.50,
          "image": "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&q=80&w=400",
          "rating": 4.8,
          "reviews": 850
        },
        {
          "id": "3",
          "name": "Volumizing Mascara",
          "brand": "Rare Beauty",
          "price": 28.00,
          "image": "https://images.unsplash.com/photo-1631214500115-598fc2cb8d2d?auto=format&fit=crop&q=80&w=400",
          "rating": 4.2,
          "reviews": 230
        },
        {
          "id": "4",
          "name": "Night Recovery Cream",
          "brand": "Estée Lauder",
          "price": 95.00,
          "image": "https://images.unsplash.com/photo-1616683693504-3ea7e9ad6fec?auto=format&fit=crop&q=80&w=400",
          "rating": 4.9,
          "reviews": 1500
        },
         {
          "id": "5",
          "name": "Eau de Parfum",
          "brand": "Chanel",
          "price": 135.00,
          "image": "https://images.unsplash.com/photo-1594035910387-fea4779426e9?auto=format&fit=crop&q=80&w=400",
          "rating": 5.0,
          "reviews": 2000
        }
      ]
    };
  }

  Map<String, dynamic> _getProductMockData() {
    return {
      "id": "1",
      "name": "Luxury Matte Lipstick",
      "brand": "Sephora Collection",
      "price": 45.00,
      "description": "A long-lasting, soft matte lipstick that delivers intense color and hydration. Infused with vitamin E for a comfortable feel.",
      "images": [
        "https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&q=80&w=800",
        "https://images.unsplash.com/photo-1617220828111-eb24120a50f2?auto=format&fit=crop&q=80&w=800", 
        "https://images.unsplash.com/photo-1625093742435-09c69206800d?auto=format&fit=crop&q=80&w=800"
      ],
      "rating": 4.5,
      "reviews": 120,
      "related": [
         {
          "id": "3",
          "name": "Volumizing Mascara",
          "brand": "Rare Beauty",
          "price": 28.00,
          "image": "https://images.unsplash.com/photo-1631214500115-598fc2cb8d2d?auto=format&fit=crop&q=80&w=400",
        }
      ]
    };
  }
}
