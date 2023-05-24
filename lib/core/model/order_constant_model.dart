const String collectionOrderConstant = 'Utils';
const String documentsOrderConstant = 'OrderConstants';
const String orderConFieldDiscount = 'discount';
const String orderConFieldVat = 'vat';
const String orderConFieldDeliCharge = 'deliveryCharge';
const String orderConFieldDeliveryTime = 'deliveryTime';
const String orderConFieldFlashTime = 'flashSellTime';
const String orderConFieldPhoneNumber = 'phoneNumber';

class OrderConstantModel {
  num discount;
  num vat;
  num deliveryCharge;
  num deliveryTime;
  num flashSellTime;
  num phoneNumber;

  OrderConstantModel({
    this.discount = 0,
    this.vat = 0,
    this.deliveryCharge = 0,
    this.deliveryTime = 7,
    this.flashSellTime = 1,
    this.phoneNumber = 019326106232,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderConFieldDiscount: discount,
      orderConFieldVat: vat,
      orderConFieldDeliCharge: deliveryCharge,
      orderConFieldDeliveryTime: deliveryTime,
      orderConFieldFlashTime: flashSellTime,
      orderConFieldPhoneNumber: phoneNumber,
    };
  }

  factory OrderConstantModel.fromMap(Map<String, dynamic> map) =>
      OrderConstantModel(
        discount: map[orderConFieldDiscount],
        vat: map[orderConFieldVat],
        deliveryCharge: map[orderConFieldDeliCharge],
        deliveryTime: map[orderConFieldDeliveryTime],
        flashSellTime: map[orderConFieldFlashTime],
      );
}
