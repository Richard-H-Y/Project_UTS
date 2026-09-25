import 'package:flutter/material.dart';
import '../models/marketplace_item.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatefulWidget {
  final List<MarketplaceItem> items;
  final void Function(MarketplaceItem item) onRemove;

  const CartPage({
    super.key,
    required this.items,
    required this.onRemove,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _remove(MarketplaceItem item) {
    setState(() {
      widget.onRemove(item);
    });
  }

  int _parsePrice(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  String _formatPrice(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromRight = str.length - i;
      buffer.write(str[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  int get _total {
    return widget.items.fold(0, (sum, item) => sum + _parsePrice(item.price));
  }

  void _checkout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout Berhasil'),
        content: Text('${widget.items.length} barang berhasil dibeli seharga ${_formatPrice(_total)}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
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
        foregroundColor: Colors.black87,
        title: const Text('Keranjang'),
      ),
      body: widget.items.isEmpty
          ? const Center(
              child: Text('Keranjang masih kosong', style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return CartItemTile(item: item, onRemove: () => _remove(item));
              },
            ),
      bottomNavigationBar: widget.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(
                            _formatPrice(_total),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _checkout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
