import 'package:ecommerce_app/core/di/injection.dart';
import 'package:ecommerce_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:ecommerce_app/features/search/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query));
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchBloc>().add(const SearchQueryChanged(''));
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            return MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 280, // Fixed height for consistency or dynamic
                  child: ProductCard(product: state.results[index]),
                );
              },
            );
          } else if (state is SearchEmpty) {
            return const Center(child: Text('No results found.'));
          } else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          
          // Initial State - Show "Trending" or just a placeholder
          // Trigger a trending search if needed, or show empty state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Search for "lipstick", "serum"...', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          );
        },
      ),
    );
  }
}
