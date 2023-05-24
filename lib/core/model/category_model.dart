const String collectionCategory='Categories';

const String categoryFieldId='categoryId';
const String categoryFieldIcon='icon';
const String categoryFieldName='categoryName';
const String categoryFieldProductCount='productCount';


class CategoryModel{

  String? categoryId;
  String categoryName;
  String icon;
  num productCount;

  CategoryModel({
    this.categoryId,
    required this.categoryName,
    required this.icon,
     this.productCount=0,
  });

  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      categoryFieldId:categoryId,
      categoryFieldName:categoryName,
      categoryFieldProductCount:productCount,
      categoryFieldIcon:icon,
    };
  }

  factory CategoryModel.fromMap(Map<String,dynamic>map)=>CategoryModel(
    categoryId: map[categoryFieldId],
    categoryName: map[categoryFieldName],
    productCount: map[categoryFieldProductCount],
    icon: map[categoryFieldIcon],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}