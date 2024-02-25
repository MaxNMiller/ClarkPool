import UIKit
import MapKit
import CoreLocation
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    
  
    @IBAction func startRouteButtonPressed(_ sender: UIButton) {
        getDirections()
        sender.isHidden = true
    }
    
        let locationManager = CLLocationManager()
        var currentCoordinate: CLLocationCoordinate2D!
        
        var steps = [MKRouteStep]()
        let speechSynthesizer = AVSpeechSynthesizer()
        
        var stepCounter = 0
        let mpg: Double = 25 // Replace with your actual miles per gallon value

        override func viewDidLoad() {
            super.viewDidLoad()

            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }

        func getDirections() {
            // Hardcoded destination coordinates
            let destinationCoordinate = CLLocationCoordinate2D(latitude: 42.259274, longitude: -71.824193)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

            let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

            let directionsRequest = MKDirectionsRequest()
            directionsRequest.source = sourceMapItem
            directionsRequest.destination = destinationMapItem
            directionsRequest.transportType = .automobile

            let directions = MKDirections(request: directionsRequest)
            directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
                return
            }
                

            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.removeAnnotations(self.mapView.annotations)

            var totalGasConsumed = 0.0

            for i in 0 ..< response.routes.count {
                let route = response.routes[i]
                self.mapView.add(route.polyline)

                self.steps = route.steps
                for j in 0 ..< route.steps.count {
                    let step = route.steps[j]
                    print(step.instructions)
                    print(step.distance)

                    // Calculate gas consumed for each step
                    let distanceInMiles = Measurement(value: step.distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value
                    let gasConsumed = distanceInMiles / self.mpg
                    totalGasConsumed += gasConsumed

                    let region = CLCircularRegion(center: step.polyline.coordinate,
                                                  radius: 20,
                                                  identifier: "\(i)_\(j)")
                    self.locationManager.startMonitoring(for: region)
                    let circle = MKCircle(center: region.center, radius: 7)
                    self.mapView.add(circle)
                }
            }
                

            // Update gasLabel with total gas consumed
            let gasMessage = String(format: "%.2f gallons", totalGasConsumed)
            self.gasLabel.text = gasMessage
            print(gasMessage)

                let initialMessage = "In \(Int(self.steps[0].distance.rounded())) feet, \(self.steps[0].instructions)."
            self.directionsLabel.text = initialMessage
            let speechUtterance = AVSpeechUtterance(string: initialMessage)
            self.speechSynthesizer.speak(speechUtterance)
            self.stepCounter += 1
        }
    }

}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        mapView.userTrackingMode = .followWithHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED")
        stepCounter += 1
        if stepCounter < steps.count {
            let currentStep = steps[stepCounter]
            let message = "In \(Int(currentStep.distance.rounded())) feet, \(currentStep.instructions)"
            directionsLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
        } else {
            let message = "Arrived at destination"
            directionsLabel.text = message
            let speechUtterance = AVSpeechUtterance(string: message)
            speechSynthesizer.speak(speechUtterance)
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            // Perform the segue when the destination is reached
            performSegue(withIdentifier: "Destination", sender: self)
        }
    }

}


extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .init(red: 0.38, green: 0.85, blue: 0.22, alpha: 1.0)
            renderer.lineWidth = 10
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .brown
            renderer.fillColor = .brown
            renderer.alpha = 0
            return renderer
        }
        return MKOverlayRenderer()
    }
}

