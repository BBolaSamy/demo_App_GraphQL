import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(title: "GQL App", home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink as Link,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatelessWidget {

  final String query = r"""
                    query{
                      continent(code:"AF"){
                        name
                        countries{
                          name
                          capital
                          
                        }
    
                      }
                    }
                  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First APP GraphlQL "),
      ),
      body: Query(
        options: QueryOptions(
            document: query, variables: <String, dynamic>{"code": "AS"}),
        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
          if (result.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.data == null) {
            return Text("No Data Found !");
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title:
                    Text("country : "+result.data['continent']['countries'][index]['name']),
                    subtitle: Text("capital : "+result.data['continent']['countries'][index]['capital']),
              );
            },
            itemCount: result.data['continent']['countries'].length,
          );
        },
      ),
    );
  }
}
