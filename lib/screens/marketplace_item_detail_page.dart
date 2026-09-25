import 'package:flutter/material.dart';
import '../models/marketplace_item.dart';

class MarketplaceItemDetailPage extends StatelessWidget {
  final MarketplaceItem item;
  final VoidCallback onAddToCart;

  const MarketplaceItemDetailPage({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  void _addToCart(BuildContext context) {
    onAddToCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${item.title}" ditambahkan ke keranjang')),
    );
  }

  void _buyNow(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembelian Berhasil'),
        content: Text('Kamu berhasil membeli "${item.title}" seharga ${item.price}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        title: const Text('Detail Barang'),
      ),
      body: ListView(
        children: [
          Image.network(
            item.imageUrl,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.price,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item.location, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const Divider(height: 28),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF1877F2),
                      child: Icon(Icons.storefront, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.seller, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Penjual', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToCart(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Keranjang'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1877F2),
                    side: const BorderSide(color: Color(0xFF1877F2)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _buyNow(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Beli Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
