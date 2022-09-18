import UIKit
import CoreML

// Don't forget to add to the project:
// 1. DeepLabV3 - https://developer.apple.com/machine-learning/models/
// 2. CoreMLHelpers - https://github.com/hollance/CoreMLHelpers

enum RemoveBackroundResult {
    case background
    case finalImage
}

extension UIImage {

    func removeBackground(returnResult: RemoveBackroundResult) -> UIImage? {
        guard let model = getBgRemoverModel() else { return nil }
        let width: CGFloat = 513
        let height: CGFloat = 513
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer),
        let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
        let outputCIImage = CIImage(image: outputImage),
        let maskImage = outputCIImage.removeWhitePixels(),
        let maskBlurImage = maskImage.applyBlurEffect() else { return nil }

        switch returnResult {
        case .finalImage:
            guard let resizedCIImage = CIImage(image: resizedImage),
                  let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
            let finalImage = UIImage(ciImage: compositedImage)
                .resized(to: CGSize(width: size.width, height: size.height))
            return finalImage
        case .background:
            let finalImage = UIImage(
                ciImage: maskBlurImage,
                scale: scale,
                orientation: self.imageOrientation
            ).resized(to: CGSize(width: size.width, height: size.height))
            return finalImage
        }
    }

    func applyCartoonEffects(returnResult: RemoveBackroundResult) -> UIImage? {
        guard let model = getCartoonModel() else { return nil }
        let width: CGFloat = 256
        let height: CGFloat = 256

        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(input: pixelBuffer)
        else { return nil }
        let outputBuffer = outputPredictionImage.activation_out
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }

//    func applySketchEffects(returnResult: RemoveBackroundResult) -> UIImage? {
//    
//        guard let model = getSketchModel() else { return nil }
//        let width: CGFloat = 512
//        let height: CGFloat = 512
//
//        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
//        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
//        let outputPredictionImage = try? model.prediction(input: sketchInput(input_1: pixelBuffer))
//        else { return nil }
//        let outputBuffer = outputPredictionImage.activation_out
//        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
//        let finalImage = UIImage(
//                        ciImage: outputImage,
//                        scale: scale,
//                        orientation: self.imageOrientation
//                    ).resized(to: CGSize(width: size.width, height: size.height))
//      return finalImage
//    }
//    
    func applyPaintEffects(returnResult: RemoveBackroundResult) -> UIImage? {
    
        guard let model = getPaintModel() else { return nil }
        let width: CGFloat = 512
        let height: CGFloat = 512

        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(input: pixelBuffer)
        else { return nil }
        let outputBuffer = outputPredictionImage.activation_out
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }
    
    func applyCupheadEffects(returnResult: RemoveBackroundResult) -> UIImage? {
    
        guard let model = getCupheadModel() else { return nil }
        let width: CGFloat = 640
        let height: CGFloat = 960

        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(input: pixelBuffer)
        else { return nil }
        let outputBuffer = outputPredictionImage.squeeze_out
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }
    

    
    func applyMosicEffects(returnResult: RemoveBackroundResult) -> UIImage? {
    
        guard let model = getMosaicModel() else { return nil }
        let width: CGFloat = 640
        let height: CGFloat = 960

        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(input: pixelBuffer)
        else { return nil }
        let outputBuffer = outputPredictionImage.squeeze_out
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }
    
    func applyNightEffects(returnResult: RemoveBackroundResult) -> UIImage? {
    
        guard let model = getNightModel() else { return nil }
        let width: CGFloat = 640
        let height: CGFloat = 960

        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(input: pixelBuffer)
        else { return nil }
        let outputBuffer = outputPredictionImage.squeeze_out
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
      return finalImage
    }
    
    func applyMuseEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getMuseModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
    
    func applyPrincessEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getPrincessModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
     
    
    func applyShipwreckEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getShipwreckModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
    
    
    
    
    func applyScreamEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getScreamModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
    
    
    
    func applyUdnieEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getUdnieModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
    
    
    func applyWaveEffects(returnResult: RemoveBackroundResult) -> UIImage? {

        print("applyNightEffects 1")
        guard let model = getWaveModel() else { return nil }
        print("applyNightEffects 2")

        let width: CGFloat = 512
        let height: CGFloat = 512
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer)
        else { return nil }
        
        print("applyNightEffects 3")

        let outputBuffer = outputPredictionImage.stylizedImage
        let outputImage = CIImage(cvPixelBuffer: outputBuffer, options: [:])
        let finalImage = UIImage(
                        ciImage: outputImage,
                        scale: scale,
                        orientation: self.imageOrientation
                    ).resized(to: CGSize(width: size.width, height: size.height))
        
        print("applyNightEffects 4")

      return finalImage
    }
    
    
    private func getBgRemoverModel() -> bgRemover? {
        do {
            let config = MLModelConfiguration()
            return try bgRemover(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    
    private func getCartoonModel() -> cartoon? {
        do {
            let config = MLModelConfiguration()
            return try cartoon(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    private func getCupheadModel() -> cuphead? {
        do {
            let config = MLModelConfiguration()
            return try cuphead(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    
    private func getMosaicModel() -> mosaic? {
        do {
            let config = MLModelConfiguration()
            return try mosaic(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    
    private func getNightModel() -> night? {
        do {
            let config = MLModelConfiguration()
            return try night(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getPaintModel() -> paint? {
        do {
            let config = MLModelConfiguration()
            return try paint(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    
    private func getMuseModel() -> Muse? {
        do {
            let config = MLModelConfiguration()
            return try Muse(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getPrincessModel() -> Princess? {
        do {
            let config = MLModelConfiguration()
            return try Princess(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getShipwreckModel() -> Shipwreck? {
        do {
            let config = MLModelConfiguration()
            return try Shipwreck(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getScreamModel() -> Scream? {
        do {
            let config = MLModelConfiguration()
            return try Scream(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getUdnieModel() -> Udnie? {
        do {
            let config = MLModelConfiguration()
            return try Udnie(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }

    private func getWaveModel() -> Wave? {
        do {
            let config = MLModelConfiguration()
            return try Wave(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
 
}

extension CIImage {

    func removeWhitePixels() -> CIImage? {
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }

    func composite(with mask: CIImage) -> CIImage? {
        return CIFilter(
            name: "CISourceOutCompositing",
            parameters: [
                kCIInputImageKey: self,
                kCIInputBackgroundImageKey: mask
            ]
        )?.outputImage
    }

    func applyBlurEffect() -> CIImage? {
        let context = CIContext(options: nil)
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        clampFilter.setDefaults()
        clampFilter.setValue(self, forKey: kCIInputImageKey)

        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        currentFilter.setValue(2, forKey: "inputRadius")
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: extent) else { return nil }

        return CIImage(cgImage: cgimg)
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func chromaKeyFilter() -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()

        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }

        var data = Data()
        cubeRGB.withUnsafeBufferPointer { ptr in data = Data(buffer: ptr) }
        let colorCubeFilter = CIFilter(
            name: "CIColorCube",
            parameters: [
                "inputCubeDimension": size,
                "inputCubeData": data
            ]
        )
        return colorCubeFilter
    }

    // modified from https://developer.apple.com/documentation/coreimage/applying_a_chroma_key_effect
    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }

}



extension UIImage {
  func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
    guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
    defer { UIGraphicsEndImageContext() }
        
    let rect = CGRect(origin: .zero, size: size)
    ctx.setFillColor(color.cgColor)
    ctx.fill(rect)
    ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
    ctx.draw(image, in: rect)
        
    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }
}


extension UIImage {
 func blurredImage(radius: CGFloat) -> UIImage? {
    guard let ciImg = CIImage(image: self) else { return nil }
    let blurredImage = ciImg.clampedToExtent()
                            .applyingFilter(
                              "CIGaussianBlur",
                              parameters: [
                                kCIInputRadiusKey: radius
                              ]
                            )
                            .cropped(to: ciImg.extent)
    let context = CIContext(options: nil)
    if let outputImage = context.createCGImage(blurredImage, from:  blurredImage.extent) {
       return UIImage(cgImage: outputImage)
    }
    return nil
  }
}



extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}


extension UIImage {
 
    func mergeWith(topImage: UIImage) -> UIImage {
    let bottomImage = self

    UIGraphicsBeginImageContext(size)
    let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
    bottomImage.draw(in: areaSize)

    topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

    let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return mergedImage
    }
    
    
    class func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
            
        let newImageWidth  = max(firstImage.size.width,  secondImage.size.width )
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
            
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
            
            let firstImageDrawX  = round((newImageSize.width  - firstImage.size.width  ) / 2)
            let firstImageDrawY  = round((newImageSize.height - firstImage.size.height ) / 2)
            
            let secondImageDrawX = round((newImageSize.width  - secondImage.size.width ) / 2)
            let secondImageDrawY = round((newImageSize.height - secondImage.size.height) / 2)
            
            firstImage .draw(at: CGPoint(x: firstImageDrawX,  y: firstImageDrawY))
//            secondImage.draw(at: CGPoint(x: secondImageDrawX, y: secondImageDrawY))
        secondImage.draw(at:CGPoint(x: secondImageDrawX, y: secondImageDrawY), blendMode: .normal, alpha: 1.0)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }
}
