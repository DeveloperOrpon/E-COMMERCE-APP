const String collectionBrand = 'Brands';

const String brandFieldId = 'brandId';
const String brandFieldName = 'brandName';
const String brandFieldImageUrl = 'brandImage';

class BrandModel {
  String? brandId;
  String brandName;
  String brandImage;

  BrandModel({
    this.brandId,
    required this.brandName,
    required this.brandImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      brandFieldId: brandId,
      brandFieldName: brandName,
      brandFieldImageUrl: brandImage,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) => BrandModel(
        brandId: map[brandFieldId],
        brandName: map[brandFieldName],
        brandImage: map[brandFieldImageUrl],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandModel &&
          runtimeType == other.runtimeType &&
          brandId == other.brandId;

  @override
  int get hashCode => brandId.hashCode;
}
