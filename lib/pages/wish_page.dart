import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyWishlist extends StatefulWidget {
  const MyWishlist({Key? key}) : super(key: key);

  @override
  _MyWishlistState createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  final User currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference wishlistCollection =
      FirebaseFirestore.instance.collection("Wishlists");
  final CollectionReference savedWishlistCollection =
      FirebaseFirestore.instance.collection("SavedWish");

  late String userEmail;
  late String wishlistName;

  @override
  void initState() {
    super.initState();
    userEmail = currentUser.email!;
    wishlistName = 'My Wishlist';
  }

  void addItem() async {
    String itemName = _itemNameController.text.trim();
    String itemDescription = _itemDescriptionController.text.trim();

    if (itemName.isNotEmpty && itemDescription.isNotEmpty) {
      await wishlistCollection
          .doc(userEmail)
          .collection('items')
          .add({
            'name': itemName,
            'description': itemDescription,
          })
          .then((value) => print("Item Added"))
          .catchError((error) => print("Failed to add item: $error"));

      _itemNameController.clear();
      _itemDescriptionController.clear();
    }
  }

  void saveWishlist() async {
    // Save current wishlist data to SavedWish collection
    QuerySnapshot currentItemsSnapshot =
        await wishlistCollection.doc(userEmail).collection('items').get();

    currentItemsSnapshot.docs.forEach((doc) async {
      await savedWishlistCollection
          .doc(userEmail)
          .collection('items')
          .add(doc.data() as Map<String, dynamic>);
    });
  }

  void editWishlist(String newName, String newDescription) async {
    await wishlistCollection.doc(userEmail).set({
      'name': newName,
      'description': newDescription,
    });
    setState(() {
      wishlistName = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wishlistName),
        actions: [
          IconButton(
            onPressed: () {
              // Handle edit action
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Edit Wishlist'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: TextEditingController(text: wishlistName),
                        decoration: InputDecoration(labelText: 'Wishlist Name'),
                        onChanged: (value) => wishlistName = value,
                      ),
                      TextField(
                        controller: TextEditingController(),
                        decoration:
                            InputDecoration(labelText: 'Wishlist Description'),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        editWishlist(wishlistName, '');
                        Navigator.pop(context);
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: saveWishlist,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search this wishlist',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle add item action
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Item'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _itemNameController,
                                decoration:
                                    InputDecoration(labelText: 'Item Name'),
                              ),
                              TextField(
                                controller: _itemDescriptionController,
                                decoration: InputDecoration(
                                    labelText: 'Item Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                addItem();
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: wishlistCollection
                  .doc(userEmail)
                  .collection('items')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ListTile(
                      title: Text(doc['name']),
                      subtitle: Text(doc['description']),
                      trailing: IconButton(
                        onPressed: () {
                          // Handle delete action
                          wishlistCollection
                              .doc(userEmail)
                              .collection('items')
                              .doc(doc.id)
                              .delete()
                              .then((value) => print("Item Deleted"))
                              .catchError((error) =>
                                  print("Failed to delete item: $error"));
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
