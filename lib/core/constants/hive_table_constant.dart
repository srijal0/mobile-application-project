// lib/core/constants/hive_table_constant.dart
class HiveTableConstant {
  HiveTableConstant._();

  // Database name
  static const String dbName = "fashion_store_trendora_db";

  // NOTE: Tables -> Box : Index
  static const int authTypeId = 0;
  static const String authTable = "auth_table";

  // You can add more boxes later for features like cart, products, etc.
  static const int cartTypeId = 1;
  static const String cartTable = "cart_table";

  static const int productTypeId = 2;
  static const String productTable = "product_table";
}
