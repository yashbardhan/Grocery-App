import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context , listen: false);
    final authData = Provider.of<Auth>(context,listen:false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: GridTile(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },

            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/load.jpg'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        header: GridTileBar(
          leading: IconButton(

            icon: Icon(
              product.isFavorite?Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).hintColor,
            alignment: Alignment.topLeft,
            onPressed: () {
              product.toggleFavoriteStatus(
                authData.token,
                authData.userId,
              );
            },
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added item to cart!',
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
              );
              },
          ),
        ),
      ),
    );
  }
}

