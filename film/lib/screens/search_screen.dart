import 'package:cached_network_image/cached_network_image.dart';
import 'package:film/models/movie.dart';
import 'package:film/screens/detail_screen.dart';
import 'package:film/services/api_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResult = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchMovies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchMovies() async {
    if (_searchController.text.isEmpty){
      setState(() {
        _searchResult.clear();
      });
      return;
    }
    
    final List<Map<String, dynamic>> searchData = 
      await _apiService.searchMovies(_searchController.text);

    setState(() {
      _searchResult = searchData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyan,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Type Here to Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResult.clear();
                        });
                      }, 
                      icon: const Icon(Icons.clear)
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (BuildContext context, int index){
                  final Movie movie = _searchResult[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url){
                          return Center(
                            child: CircularProgressIndicator(color: Colors.blue,),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(movie.title),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(movie: movie)
                          )
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}