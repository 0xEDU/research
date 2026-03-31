import AppKit
import Foundation

// MARK: - Phong shading

/// Computes the full Phong illumination at a surface hit point.
///
/// - Parameters:
///   - hit:          Surface intersection data (point, normal, material).
///   - scene:        The scene containing lights and geometry.
///   - rayDirection: The unit-length incoming ray direction (toward the surface).
/// - Returns: Clamped RGB colour in [0, 1]³.
func phongShading(hit: Hit, scene: RayScene, rayDirection: Vec3) -> Vec3 {
    let mat = hit.material
    let N   = hit.normal.normalized
    let V   = (-rayDirection).normalized   // direction toward the camera

    // Ambient term — always present, regardless of shadow.
    var color = mat.color * mat.ambient

    for light in scene.lights {
        let toLight  = light.position - hit.point
        let L        = toLight.normalized   // direction toward the light

        guard !scene.isInShadow(from: hit.point, toward: light) else { continue }

        // Diffuse term: kd * (N · L) * lightColor
        let NdL = max(N.dot(L), 0.0)
        color = color + mat.color * (mat.diffuse * NdL * light.intensity) * light.color

        // Specular term: ks * (R · V)^n * lightColor
        // Reflection of L about N: R = 2(N·L)N − L
        let R   = N * (2.0 * N.dot(L)) - L
        let RdV = max(R.dot(V), 0.0)
        let spec = mat.specular * pow(RdV, mat.shininess) * light.intensity
        color = color + Vec3.one * spec * light.color
    }

    return color.clamped()
}

// MARK: - Ray Tracer

final class RayTracer {
    let width:  Int
    let height: Int

    init(width: Int = 800, height: Int = 600) {
        self.width  = width
        self.height = height
    }

    // MARK: Scene construction

    func buildScene() -> RayScene {
        // Pink ball
        let pinkMaterial = Material(
            color:     Vec3(1.0, 0.41, 0.71),   // hot-pink
            ambient:   0.12,
            diffuse:   0.70,
            specular:  0.80,
            shininess: 64.0
        )

        // Neutral grey floor
        let floorMaterial = Material(
            color:     Vec3(0.75, 0.75, 0.75),
            ambient:   0.10,
            diffuse:   0.65,
            specular:  0.10,
            shininess: 8.0
        )

        let ball  = Sphere(center: Vec3(0, 0, 0), radius: 1.0, material: pinkMaterial)
        let floor = Plane(point:  Vec3(0, -1, 0), normal: Vec3(0, 1, 0), material: floorMaterial)

        // White point light — positioned in front of the ball (between camera and ball),
        // top-left in screen space so it casts a shadow to the lower-right on the floor.
        let light = PointLight(
            position:  Vec3(-3.5, 4.0, -3.0),
            color:     Vec3(1.0, 1.0, 1.0),
            intensity: 1.0
        )

        return RayScene(
            objects:         [ball, floor],
            lights:          [light],
            backgroundColor: Vec3(0.05, 0.05, 0.10)
        )
    }

    // MARK: Rendering

    /// Renders the scene and returns an `NSImage`.
    func render() -> NSImage {
        let scene       = buildScene()
        let aspectRatio = Double(width) / Double(height)

        // Perspective camera
        let fovY            = 45.0 * Double.pi / 180.0
        let viewportHeight  = 2.0 * tan(fovY / 2.0)
        let viewportWidth   = aspectRatio * viewportHeight
        let cameraOrigin    = Vec3(0, 0, -5)
        // Lower-left corner of the image plane at z = cameraOrigin.z + 1
        let lowerLeft = cameraOrigin
            + Vec3(-viewportWidth / 2, -viewportHeight / 2, 1.0)

        var pixels = [UInt8](repeating: 0, count: width * height * 4)

        for row in 0..<height {
            for col in 0..<width {
                // UV in [0, 1]; row 0 is the top of the image.
                let u = Double(col) / Double(width  - 1)
                let v = Double(height - 1 - row) / Double(height - 1)

                let target    = lowerLeft + Vec3(viewportWidth * u, viewportHeight * v, 0)
                let direction = (target - cameraOrigin).normalized
                let ray       = Ray(origin: cameraOrigin, direction: direction)

                let color: Vec3
                if let hit = scene.closestHit(ray: ray) {
                    color = phongShading(hit: hit, scene: scene, rayDirection: ray.direction)
                } else {
                    color = scene.backgroundColor
                }

                let base = (row * width + col) * 4
                pixels[base + 0] = UInt8(color.x * 255.999)
                pixels[base + 1] = UInt8(color.y * 255.999)
                pixels[base + 2] = UInt8(color.z * 255.999)
                pixels[base + 3] = 255
            }
        }

        return makeImage(pixels: pixels)
    }

    // MARK: Image construction

    private func makeImage(pixels: [UInt8]) -> NSImage {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)
        let data       = Data(pixels) as CFData
        guard
            let provider = CGDataProvider(data: data),
            let cgImage  = CGImage(
                width:            width,
                height:           height,
                bitsPerComponent: 8,
                bitsPerPixel:     32,
                bytesPerRow:      width * 4,
                space:            colorSpace,
                bitmapInfo:       bitmapInfo,
                provider:         provider,
                decode:           nil,
                shouldInterpolate: false,
                intent:           .defaultIntent
            )
        else {
            return NSImage()
        }
        return NSImage(cgImage: cgImage, size: NSSize(width: width, height: height))
    }
}
