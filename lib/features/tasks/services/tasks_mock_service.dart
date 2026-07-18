import '../models/task_model.dart';

class TasksMockService {
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network lag
    return [
      TaskModel(
        id: "T-1001",
        title: "Pick Order #8821",
        description: "Pick 5 items from A-12-3",
        type: TaskType.pick,
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        location: "A-12-3",
      ),
      TaskModel(
        id: "T-1002",
        title: "Pack Shipment #SH-992",
        description: "Pack 12 units of 'Wireless Headphones'",
        type: TaskType.pack,
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        location: "Packing-Station-4",
      ),
      TaskModel(
        id: "T-1003",
        title: "Receive PO #PO-4451",
        description: "Verify 50 boxes from 'Tech Giant Inc.'",
        type: TaskType.receive,
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        location: "Dock-2",
      ),
      TaskModel(
        id: "T-1004",
        title: "Inventory Count Section B",
        description: "Annual cycle count for Electronics",
        type: TaskType.count,
        priority: TaskPriority.low,
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        location: "Zone-B",
      ),
      TaskModel(
        id: "T-1005",
        title: "Ship Manifest #M-772",
        description: "Load truck with 24 pallets",
        type: TaskType.ship,
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        location: "Dock-5",
      ),
      TaskModel(
        id: "T-1006",
        title: "Pick Order #8825",
        description: "Pick 2 items from C-05-1",
        type: TaskType.pick,
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        location: "C-05-1",
      ),
    ];
  }
}
