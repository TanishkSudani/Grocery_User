// import 'package:flutter/material.dart';
// import 'package:search_page/search_page.dart';
//
// import '../database/product_model.dart';
//
// class ProductSearch extends StatelessWidget {
//   const ProductSearch({super.key});
//   static List<Product> products = [
//     Product('Mike', 'Barron', 64),
//     Product('Mike', 'Barron', 64),
//     Product('Mike', 'Barron', 64),
//     Product('Mike', 'Barron', 64),
//     Product('Mike', 'Barron', 64),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Page'),
//       ),
//       body: ListView.builder(
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           final Product product = products[index];
//
//           return ListTile(
//             title: Text(product.name),
//             subtitle: Text(product.surname),
//             trailing: Text('${product.age} yo'),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         tooltip: 'Search people',
//         onPressed: () => showSearch(
//           context: context,
//           delegate: SearchPage<Product>(
//             onQueryUpdate: print,
//             items: products,
//             searchLabel: 'Search people',
//             suggestion: const Center(
//               child: Text('Filter people by name, surname or age'),
//             ),
//             failure: const Center(
//               child: Text('No person found :('),
//             ),
//             filter: (person) => [
//               person.name,
//               person.surname,
//               person.age.toString(),
//             ],
//            // sort: (a, b) => a.compareTo(b),
//             builder: (person) => ListTile(
//               title: Text(person.name),
//               subtitle: Text(person.surname),
//               trailing: Text('${person.age} yo'),
//             ),
//           ),
//         ),
//         child: const Icon(Icons.search),
//       ),
//     );
//   }
// }
