import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine.dart';
import '../services/wishlist_service.dart';

final wishlistServiceProvider = Provider<WishlistService>((ref) => WishlistService());
final wishlistProvider = FutureProvider<List<Medicine>>((ref) => ref.read(wishlistServiceProvider).getItems());
