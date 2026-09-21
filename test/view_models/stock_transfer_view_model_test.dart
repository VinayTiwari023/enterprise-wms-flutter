import 'package:enterprise_wms/core/enums/view_status.dart';
import 'package:enterprise_wms/features/inventory/models/inventory_item_model.dart';
import 'package:enterprise_wms/features/inventory/models/stock_transfer_model.dart';
import 'package:enterprise_wms/features/inventory/repositories/inventory_repository.dart';
import 'package:enterprise_wms/features/inventory/viewmodels/stock_transfer_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class FakeStockTransferModel extends Fake implements StockTransferModel {}

class FakeInventoryItemModel extends Fake implements InventoryItemModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeStockTransferModel());
    registerFallbackValue(FakeInventoryItemModel());
  });

  group('StockTransferViewModel Tests -', () {
    late ProviderContainer container;
    late MockInventoryRepository mockRepo;

    final testItem = InventoryItemModel(
      name: 'Wireless Barcode Scanner',
      sku: 'SKU-SCAN-01',
      location: 'A-01-02',
      units: 50,
      status: 'Available',
    );

    setUp(() {
      mockRepo = MockInventoryRepository();
      when(() => mockRepo.fetchTransferHistory()).thenAnswer((_) async => []);
      when(() => mockRepo.saveStockTransfer(any())).thenAnswer((_) async {});
      when(() => mockRepo.saveItem(any())).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [inventoryRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial status should be idle', () {
      final state = container.read(stockTransferViewModelProvider);
      expect(state.status, ViewStatus.idle);
      expect(state.selectedItem, isNull);
    });

    test('selectItem sets item and source location', () {
      final notifier = container.read(stockTransferViewModelProvider.notifier);
      notifier.selectItem(testItem);

      final state = container.read(stockTransferViewModelProvider);
      expect(state.selectedItem, testItem);
      expect(state.fromLocation, 'A-01-02');
      expect(state.quantity, 1);
    });

    test('executeTransfer fails if no item is selected', () async {
      final notifier = container.read(stockTransferViewModelProvider.notifier);
      final result = await notifier.executeTransfer('Operator');

      final state = container.read(stockTransferViewModelProvider);
      expect(result, isFalse);
      expect(state.status, ViewStatus.error);
      expect(state.errorMessage, contains('Please select an item'));
    });

    test(
      'executeTransfer fails if destination bin is same as source bin',
      () async {
        final notifier = container.read(
          stockTransferViewModelProvider.notifier,
        );
        notifier.selectItem(testItem);
        notifier.setToLocation('A-01-02');

        final result = await notifier.executeTransfer('Operator');

        final state = container.read(stockTransferViewModelProvider);
        expect(result, isFalse);
        expect(state.status, ViewStatus.error);
        expect(state.errorMessage, contains('cannot be the same'));
      },
    );

    test('executeTransfer fails if quantity exceeds available stock', () async {
      final notifier = container.read(stockTransferViewModelProvider.notifier);
      notifier.selectItem(testItem);
      notifier.setToLocation('B-04-12');
      notifier.setQuantity(100); // 100 > 50

      final result = await notifier.executeTransfer('Operator');

      final state = container.read(stockTransferViewModelProvider);
      expect(result, isFalse);
      expect(state.status, ViewStatus.error);
      expect(state.errorMessage, contains('exceeds available stock'));
    });

    test('executeTransfer succeeds with valid parameters', () async {
      final notifier = container.read(stockTransferViewModelProvider.notifier);
      notifier.selectItem(testItem);
      notifier.setToLocation('B-04-12');
      notifier.setQuantity(10);
      notifier.setReason('Bin Consolidation');

      final result = await notifier.executeTransfer('Vinay');

      final state = container.read(stockTransferViewModelProvider);
      expect(result, isTrue);
      expect(state.status, ViewStatus.success);
      expect(state.successMessage, contains('Transferred 10 units'));
      verify(() => mockRepo.saveStockTransfer(any())).called(1);
    });
  });
}
