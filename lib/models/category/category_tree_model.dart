class CategoryTreeResponse {
  final String? success;
  final int? status;
  final String? message;
  final List<CategoryNode>? data;

  CategoryTreeResponse({this.success, this.status, this.message, this.data});

  factory CategoryTreeResponse.fromJson(Map<String, dynamic> json) {
    return CategoryTreeResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => CategoryNode.fromJson(i)).toList()
          : null,
    );
  }
}

class CategoryNode {
  final int? id;
  final int? parentId;
  final String? name;
  final String? slug;
  final String? image;
  final int? status;
  final int? sortOrder;
  final List<CategoryNode>? children;

  CategoryNode({
    this.id,
    this.parentId,
    this.name,
    this.slug,
    this.image,
    this.status,
    this.sortOrder,
    this.children,
  });

  factory CategoryNode.fromJson(Map<String, dynamic> json) {
    return CategoryNode(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      status: json['status'],
      sortOrder: json['sort_order'],
      children: json['children'] != null
          ? (json['children'] as List).map((i) => CategoryNode.fromJson(i)).toList()
          : [],
    );
  }
}
