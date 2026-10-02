import 'package:flutter/material.dart';
import '../models/marketplace_item.dart';
import '../widgets/marketplace_item_card.dart';
import 'marketplace_item_detail_page.dart';
import 'cart_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final List<MarketplaceItem> _items = [
    MarketplaceItem(
      title: 'Sepeda Gunung Bekas',
      price: 'Rp 1.500.000',
      location: 'Jakarta Barat',
      imageUrl: 'https://png.pngtree.com/png-clipart/20250416/original/pngtree-red-mountain-bike-png-image_20702371.png',
      seller: 'Richard',
      category: 'Olahraga',
      description:
          'Sepeda gunung kondisi 90%, jarang dipakai. Rem dan gear masih normal.',
    ),
    MarketplaceItem(
      title: 'Meja Belajar Kayu',
      price: 'Rp 350.000',
      location: 'Tangerang',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ9cC9iGfjChI7Q_XwF4Jpo1cm1T8RRyyorlom2oa1OqaqIPZbSSPODs4&s=10',
      seller: 'Elysia',
      category: 'Furnitur',
      description:
          'Meja belajar kayu solid. Cocok untuk kerja/belajar dari rumah. Kondisi mulus, tanpa cacat.',
    ),
    MarketplaceItem(
      title: 'Kamera Analog',
      price: 'Rp 800.000',
      location: 'Jakarta Selatan',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzqv3OIzqldYt4iYHbCG3jyBT9r_xx1ic31_iGRLYnZi2UVXWaTKXn30I&s=10',
      seller: 'Andrian',
      category: 'Elektronik',
      description:
          'Kamera analog vintage, masih bisa dipakai normal.',
    ),
    MarketplaceItem(
      title: 'Sepatu Lari Ukuran 42',
      price: 'Rp 250.000',
      location: 'Jakarta Utara',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMq48k4sdGMxGBEFDiVTuuR8EvOp_3bH8aU9eo5ODuM5rOgS8dR57pkTm6&s=10',
      seller: 'Surya',
      category: 'Fashion',
      description:
          'Sepatu lari ukuran 42, dipakai beberapa kali saja. Masih nyaman dan empuk untuk dipakai olahraga sehari-hari.',
    ),
    MarketplaceItem(
      title: 'Rak Buku Minimalis',
      price: 'Rp 275.000',
      location: 'Bekasi',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdHBnB4j6CoP2UwPFou7ljIcg1t7CtVxC8Havd6Qyn0A1nfIrk9I37C1U&s=100',
      seller: 'Kevin',
      category: 'Furnitur',
      description:
          'Rak buku minimalis. Ringan dan mudah dipindah, cocok untuk kamar kos atau apartemen.',
    ),
    MarketplaceItem(
      title: 'Keyboard Mechanical',
      price: 'Rp 450.000',
      location: 'Jakarta Barat',
      imageUrl: 'https://kbdfans.com/cdn/shop/files/JUN_5926.jpg?v=1789521139&width=1400',
      seller: 'Cathrine',
      category: 'Elektronik',
      description:
          'Keyboard mechanical. Cocok untuk gaming atau kerja. Kondisi masih sangat baik.',
    ),
  ];

  final List<MarketplaceItem> _cart = [];

  void _addToCart(MarketplaceItem item) {
    setState(() {
      _cart.add(item);
    });
  }

  void _removeFromCart(MarketplaceItem item) {
    setState(() {
      _cart.remove(item);
    });
  }

  void _openDetail(MarketplaceItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketplaceItemDetailPage(
          item: item,
          onAddToCart: () => _addToCart(item),
        ),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          items: _cart,
          onRemove: _removeFromCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Marketplace',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                onPressed: _openCart,
                tooltip: 'Keranjang',
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return MarketplaceItemCard(
            item: item,
            onTap: () => _openDetail(item),
          );
        },
      ),
    );
  }
}
