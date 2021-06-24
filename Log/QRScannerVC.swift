//
//  File.swift
//  Log
//
//  Created by Taras Shukhman on 24/06/2021.
//


import AVFoundation
import UIKit
import CoreData
//MARK: - Class
class QRScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "QR"
        
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        let videoInput: AVCaptureInput
        
        do{
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            failed()
            return
        }
        
        if (captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 20, y: 200, width: view.bounds.width - 40, height: 300)
        previewLayer.cornerRadius = 5
        
        
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false){
            captureSession.startRunning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
               captureSession.stopRunning()
           }
       }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    

                        if let qrUrl = object.stringValue {
                            
                            let service = Networking()
                            service.getDataQR(qrUrl: qrUrl) { (result) in
                                switch result {
                                case .Success(let data):
                                    DispatchQueue.main.async {
                                    self.saveInCoreDataWith(array: data)
                                    }
                                case .Error:
                                    DispatchQueue.main.async {
                                        let cv = UIAlertController(title: "Invalid QR", message: "try again", preferredStyle: .alert)
                                        cv.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [self] _ in                                             captureSession.startRunning()}))
                                        cv.addAction(UIAlertAction(title: "Close", style: .cancel, handler: {_ in
                                            self.dismiss(animated: true)}))
                                        self.present(cv, animated: true)
                                    }
                                }
                            }
                        }

                    self.navigationController?.popViewController(animated: true)

                    
                   
                    self.captureSession.stopRunning()

                }
            }
        }
    }
    
    
    
    
    
    
    
    func failed(){
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
        captureSession = nil
    }
    
    override var prefersStatusBarHidden: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }

    
    private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = Database.shared.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movies", into: context) as? Movies {
            movieEntity.title = dictionary["title"] as! String
            movieEntity.image = dictionary["image"] as! String
            movieEntity.releaseYear = dictionary["releaseYear"] as! Int16
            movieEntity.rating = dictionary["rating"] as! Float
            movieEntity.genre = dictionary["genre"] as! [String]
            return movieEntity
        }
        return nil
    }
    private func saveInCoreDataWith(array: [String: AnyObject]) {
//        _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
        _  = self.createMovieEntityFrom(dictionary: array)
        do {
            try Database.shared.persistentContainer.viewContext.save()

        } catch let error {
            print(error.localizedDescription)
        }
    }
   
    
    

}
