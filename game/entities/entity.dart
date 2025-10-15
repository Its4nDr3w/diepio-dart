abstract class Entity {
  // Vị trí hiện tại
  double x;
  double y;
  // Vận tốc hiện tại
  double vx;
  double vy;
  // Bán kính (kích thước)
  double radius;
  // Khối lượng (dùng cho va chạm, vật lý)
  double mass;

  /// Khởi tạo entity với vị trí, vận tốc, kích thước, khối lượng
  Entity({
    required this.x,
    required this.y,
    this.vx = 0,
    this.vy = 0,
    required this.radius,
    required this.mass,
  });

  /// Cập nhật vị trí entity theo vận tốc mỗi frame
  void update() {
    x += vx;
    y += vy;
  }
}
