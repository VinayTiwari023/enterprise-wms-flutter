enum LabelType { skuBarcode, binTag, palletLPN, shippingSlip }

class LabelData {
  final LabelType type;
  final String title;
  final String primaryCode; // SKU, Bin Code, LPN #, or Order #
  final String subTitle;
  final String zoneOrLocation;
  final String details;
  final int quantity;

  const LabelData({
    required this.type,
    required this.title,
    required this.primaryCode,
    required this.subTitle,
    required this.zoneOrLocation,
    required this.details,
    this.quantity = 1,
  });
}
