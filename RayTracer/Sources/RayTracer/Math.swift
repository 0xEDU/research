import Foundation

// MARK: - Vec3

struct Vec3 {
    var x, y, z: Double

    static let zero = Vec3(0, 0, 0)
    static let one  = Vec3(1, 1, 1)

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    // Arithmetic
    static func + (lhs: Vec3, rhs: Vec3) -> Vec3 { Vec3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z) }
    static func - (lhs: Vec3, rhs: Vec3) -> Vec3 { Vec3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z) }
    static func * (lhs: Vec3, rhs: Vec3) -> Vec3 { Vec3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z) }
    static func * (lhs: Vec3, rhs: Double) -> Vec3 { Vec3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs) }
    static func * (lhs: Double, rhs: Vec3) -> Vec3 { Vec3(lhs * rhs.x, lhs * rhs.y, lhs * rhs.z) }
    static prefix func - (v: Vec3) -> Vec3 { Vec3(-v.x, -v.y, -v.z) }

    var lengthSquared: Double { x * x + y * y + z * z }
    var length: Double { sqrt(lengthSquared) }
    var normalized: Vec3 { self * (1.0 / length) }

    func dot(_ other: Vec3) -> Double { x * other.x + y * other.y + z * other.z }

    /// Clamp each component to [0, 1].
    func clamped() -> Vec3 {
        Vec3(min(max(x, 0), 1), min(max(y, 0), 1), min(max(z, 0), 1))
    }
}

// MARK: - Ray

struct Ray {
    let origin: Vec3
    /// Unit-length direction vector.
    let direction: Vec3

    func at(_ t: Double) -> Vec3 { origin + direction * t }
}
