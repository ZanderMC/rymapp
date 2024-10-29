import 'package:aymapp/providers/api_provider.dart';
import 'package:aymapp/widgets/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final apiprovider = Provider.of<ApiProvider>(context, listen: false);
    apiprovider.getCharacters(page);

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiprovider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiprovider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rick and morty ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchCharacter());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: apiprovider.characters.isNotEmpty
              ? Characterlist(
                  apiprovider: apiprovider,
                  isLoading: isLoading,
                  scrollcontroller: scrollController,
                )
              : const Center(child: CircularProgressIndicator()),
        ));
  }
}

class Characterlist extends StatelessWidget {
  const Characterlist(
      {super.key,
      required this.apiprovider,
      required this.scrollcontroller,
      required this.isLoading});
  final ApiProvider apiprovider;
  final ScrollController scrollcontroller;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      controller: scrollcontroller,
      itemCount: apiprovider.characters.length,
      itemBuilder: (context, index) {
        final character = apiprovider.characters[index];
        return GestureDetector(
          onTap: () {
            context.push("/CharacterScreen", extra: character);
          },
          child: Card(
            child: Column(
              children: [
                Hero(
                  tag: character.id!,
                  child: FadeInImage(
                      placeholder: const AssetImage("assets/images/portal.gif"),
                      image: NetworkImage(character.image!)),
                ),
                Text(
                  character.name!,
                  style: const TextStyle(
                      fontSize: 16, overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
