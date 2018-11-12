
/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A custom anchor for saving a snapshot image in an ARWorldMap.
 */

import ARKit

/// - Tag: SnapshotAnchor
class SnapshotAnchor: ARAnchor {
    
    let imageData: Data
    
    convenience init?(capturing view: ARSCNView) {
        guard let frame = view.session.currentFrame
            else { return nil }
        
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let orientation = CGImagePropertyOrientation(cameraOrientation: UIDevice.current.orientation)
        
        let context = CIContext(options: [.useSoftwareRenderer: false])
        guard let data = context.jpegRepresentation(of: image.oriented(orientation),
                                                    colorSpace: CGColorSpaceCreateDeviceRGB(),
                                                    options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.7])
            else { return nil }
        
        self.init(imageData: data, transform: frame.camera.transform)
    }
    
    init(imageData: Data, transform: float4x4) {
        self.imageData = imageData
        super.init(name: "snapshot", transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        self.imageData = (anchor as! SnapshotAnchor).imageData
        super.init(anchor: anchor)
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let snapshot = aDecoder.decodeObject(forKey: "snapshot") as? Data {
            self.imageData = snapshot
        } else {
            return nil
        }
        
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(imageData, forKey: "snapshot")
    }
    
}

/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Convenience extensions on system types.
 */

import simd
import ARKit

extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        }
    }
}

extension ARCamera.TrackingState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .notAvailable:
            return "Not Available"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.excessiveMotion):
            return "Excessive Motion"
        case .limited(.insufficientFeatures):
            return "Insufficient Features"
        case .limited(.relocalizing):
            return "Relocalizing"
        }
    }
}

extension ARCamera.TrackingState {
    var localizedFeedback: String {
        switch self {
        case .normal:
            // No planes detected; provide instructions for this app's AR interactions.
            return "Move around to map the environment."
            
        case .notAvailable:
            return "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            return "Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            return "Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.relocalizing):
            return "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            return "Initializing AR session."
        }
    }
}

extension ARWorldMap {
    var snapshotAnchor: SnapshotAnchor? {
        return anchors.compactMap { $0 as? SnapshotAnchor }.first
    }
}

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   buttonTitle: String = "OK",
                   showCancel: Bool = false,
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        print(title + "\n" + message)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
        if showCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension CGImagePropertyOrientation {
    /// Preferred image presentation orientation respecting the native sensor orientation of iOS device camera.
    init(cameraOrientation: UIDeviceOrientation) {
        switch cameraOrientation {
        case .portrait:
            self = .right
        case .portraitUpsideDown:
            self = .left
        case .landscapeLeft:
            self = .up
        case .landscapeRight:
            self = .down
        default:
            self = .right
        }
    }
}

