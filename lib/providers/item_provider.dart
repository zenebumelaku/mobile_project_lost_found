import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';

class ItemProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LostFoundItem> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Lost', 'Found'

  List<LostFoundItem> get items {
    return _items.where((item) {
      final matchesSearch =
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' ||
          item.type == _selectedFilter ||
          item.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<LostFoundItem> get allItems => _items;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // READ
  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _items = await _apiService.fetchItems();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addItem(LostFoundItem item) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newItem = await _apiService.createItem(item);
      _items.insert(0, newItem);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE
  Future<bool> editItem(LostFoundItem updatedItem) async {
    if (updatedItem.id == null) return false;
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.updateItem(updatedItem.id!, updatedItem);
      int index = _items.indexWhere((element) => element.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE
  Future<bool> removeItem(String id) async {
    try {
      await _apiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}
