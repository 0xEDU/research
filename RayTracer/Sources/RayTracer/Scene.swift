import Foundation

// MARK: - Material

/// Phong reflection material properties.
struct Material {
    /// Base (diffuse) color of the surface (RGB in [0, 1]).
    let color: Vec3
    /// Ambient reflection coefficient.
    let ambient: Double
    /// Diffuse reflection coefficient.
    let diffuse: Double
    /// Specular reflection coefficient.
    let specular: Double
    /// Shininess exponent (higher → sharper highlight).
    let shininess: Double
}

// MARK: - Point Light

struct PointLight {
    let position: Vec3
    /// Light color (white = Vec3(1, 1, 1)).
    let color: Vec3
    let intensity: Double
}

// MARK: - Hit record

struct Hit {
    let t: Double
    let point: Vec3
    let normal: Vec3   // outward-facing, unit length
    let material: Material
}

// MARK: - Hittable protocol

protocol Hittable {
    func intersect(ray: Ray, tMin: Double, tMax: Double) -> Hit?
}

// MARK: - Sphere

struct Sphere: Hittable {
    let center: Vec3
    let radius: Double
    let material: Material

    func intersect(ray: Ray, tMin: Double, tMax: Double) -> Hit? {
        let oc = ray.origin - center
        let a  = ray.direction.dot(ray.direction)
        let hb = oc.dot(ray.direction)
        let c  = oc.dot(oc) - radius * radius
        let discriminant = hb * hb - a * c

        guard discriminant >= 0 else { return nil }

        let sqrtD = sqrt(discriminant)
        var t = (-hb - sqrtD) / a
        if t < tMin || t > tMax {
            t = (-hb + sqrtD) / a
            guard t >= tMin && t <= tMax else { return nil }
        }

        let point  = ray.at(t)
        let normal = (point - center) * (1.0 / radius)
        return Hit(t: t, point: point, normal: normal, material: material)
    }
}

// MARK: - Plane

struct Plane: Hittable {
    let point: Vec3    // any point on the plane
    let normal: Vec3   // unit normal
    let material: Material

    func intersect(ray: Ray, tMin: Double, tMax: Double) -> Hit? {
        let denom = normal.dot(ray.direction)
        guard abs(denom) > 1e-8 else { return nil }

        let t = (point - ray.origin).dot(normal) / denom
        guard t >= tMin && t <= tMax else { return nil }

        // Flip normal to face the incoming ray.
        let n = denom < 0 ? normal : -normal
        return Hit(t: t, point: ray.at(t), normal: n, material: material)
    }
}

// MARK: - Scene

struct Scene {
    let objects: [any Hittable]
    let lights: [PointLight]
    let backgroundColor: Vec3

    /// Returns the closest intersection along `ray`, or `nil` if none.
    func closestHit(ray: Ray, tMin: Double = 1e-4, tMax: Double = .infinity) -> Hit? {
        objects.reduce(nil as Hit?) { best, obj in
            let limit = best?.t ?? tMax
            if let h = obj.intersect(ray: ray, tMin: tMin, tMax: limit) { return h }
            return best
        }
    }

    /// Returns `true` when `point` is occluded from `light` by any scene object.
    func isInShadow(from point: Vec3, toward light: PointLight) -> Bool {
        let toLight  = light.position - point
        let dist     = toLight.length
        let shadowRay = Ray(origin: point, direction: toLight.normalized)
        return closestHit(ray: shadowRay, tMin: 1e-4, tMax: dist - 1e-4) != nil
    }
}
