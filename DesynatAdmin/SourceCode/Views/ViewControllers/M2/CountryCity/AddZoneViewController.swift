//
//  AddZoneViewController.swift
//  DesynatAdmin
//
//  Created by Meet Goti on 11/11/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddZoneViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var txtFieldNameEnglish: BindableTextField! {
        didSet {
            txtFieldNameEnglish.bind(callback: {self.viewModel.setEnglishName($0)})
        }
    }
    @IBOutlet weak var btnUndu: UIButton!
    @IBOutlet weak var txtFieldNameArabic: BindableTextField! {
        didSet {
            txtFieldNameArabic.bind(callback: {self.viewModel.setArabicName($0)})
        }
    }
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var btnCurrentLocation: CustomButtonFont!
    @IBOutlet weak var txtFieldSearch: BindableTextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnSubmitt: CustomButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Property Decalaration
    private var viewModel : AddZoneViewModel = AddZoneViewModel()
    private(set) var isForView : Bool = false
    private var titleString : String = ""
    private var markers: [GMSMarker] = []
    private(set) var isInitalLoad : Bool = true
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldNameArabic.delegate = self
        self.setUpUi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.viewModel.data.coordinates.isEmpty {
            self.searchLocation(text: "\(String.getString(self.viewModel.cityInfo?.name))\(String.getString(self.viewModel.cityInfo?.countryName))") { placeId in
                CommonUtils.getCoordinatesFromPlaceID(placeID: placeId) { lat, long in
                    DispatchQueue.main.async {
                        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude:long, zoom: 16.0)
                        self.mapView.camera = camera
                        self.setAreaPolyGon()
                    }
                }
            }
        } else {
            self.cameraMoveToLocation(isForCurrent: false)
            self.setAreaPolyGon()
        }
        
    }
    
    // MARK: - Button's Action
    @IBAction func tapUndo(_ sender: Any) {
        let needRefresh = self.viewModel.undoLPath()
        if (needRefresh) {
            if let lastMarker = self.markers.popLast() {
                lastMarker.map = nil
            }
            self.btnUndu.isHidden = self.viewModel.data.coordinates.isEmpty
            self.refreshPath()
        }
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func handleSubmit(_ sender: Any) {
        let errorMesage = self.viewModel.data.validate()
        if (errorMesage != .none) {
            self.showAlert(msg: errorMesage.value())
            return
        }
        self.viewModel.addZone {
            let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            vc.setTitle("Zone \(self.viewModel.isForEdit ? "Updated" : "Added")\nsuccessfully!")
            vc.callBackDismiss = {
                self.navigationController?.popViewController(animated: true)
            }
            self.presentVC(vc,modalPresentationStyle: .overCurrentContext)
        }
    }
    
    @IBAction func handleCurrentLocation(_ sender: Any) {
        self.cameraMoveToLocation(isForCurrent: true)
    }
    
    //MARK: Function's declaration
    func searchLocation(text:String,_ completion:@escaping (String) -> Void)  {
        let placesClient : GMSPlacesClient = GMSPlacesClient.shared()
        let filter = GMSAutocompleteFilter()
        CommonUtils.showHud(show: true)
        placesClient.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: GMSAutocompleteSessionToken.init()) {(results, error) in
            CommonUtils.showHud(show: false)
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if let results = results {
                printInConsole("Result:- \(results)")
                completion(String.getString(results.first?.placeID))
            } else {
                completion("")
            }
        }
    }
    func setTitle(_ string:String,isForView:Bool = false)  {
        self.titleString = string
        self.isForView = isForView
    }
    func setData(_ data:ZoneInfo,isForEdit:Bool = false)  {
        self.viewModel.setInitial(data,isForEdit: isForEdit)
    }
    
    func setCityData(_ data:CitiesInfo)  {
        self.viewModel.setCityInfo(data)
    }
    
    private func setUpUi() {
        if (!titleString.isEmpty) {
            self.lblTitle.text = titleString
        }
        if (self.viewModel.isForEdit) {
            self.txtFieldNameEnglish.text = self.viewModel.data.nameEn
            self.txtFieldNameArabic.text = self.viewModel.data.nameAr
        }
        self.txtFieldSearch.delegate = self
        self.setGoogleMapUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.btnSubmitt.backgroundColor = .clear
            self.btnSubmitt.applyGradient(colours: [UIColor.init(hexString: "#DFBF8F"), UIColor.init(hexString: "#6E4527")],gradientDirection: .topToBottom,cornerRadius: 5)
        }
        
        
    }
    
    private func setGoogleMapUI() {
        self.mapView.delegate = self
        
        self.mapView.settings.myLocationButton = false
        self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        self.btnCurrentLocation.isHidden = true
        self.imgPin.isHidden = true
        if (!self.viewModel.isForEdit) {
            if (!self.viewModel.data.nameEn.isEmpty){
                self.btnUndu.isHidden = true
                self.viewSearch.isHidden = true
                self.viewForm.isHidden = true
                
            } else {
                self.btnUndu.isHidden = self.viewModel.data.coordinates.isEmpty
            }
        }
        
        self.btnCurrentLocation.becomeFirstResponder()
        self.imgPin.becomeFirstResponder()
    }
    
    private func cameraMoveToLocation(isForCurrent:Bool = false) {
        var camera: GMSCameraPosition?
        if (isForCurrent) {
            if let location = LocationManager.sharedInstance.location {
                camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude:location.longitude, zoom: 16.0)
            }
        } else {
            if let location = self.viewModel.data.coordinates.first {
                camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude:location.longitude, zoom: 16.0)
            }
        }
        
        if let camera = camera {
            self.mapView.camera = camera
        }
        
    }
    private(set) var polyGonPath : GMSMutablePath?
    let polygon = GMSPolygon()
    
    private func setAreaPolyGon() {
        self.polyGonPath = GMSMutablePath()
        self.viewModel.data.coordinates.forEach({polyGonPath?.add($0)})
        if let polyGonPath {
            polygon.path = polyGonPath
        }
        polygon.title = ""
        polygon.fillColor = UIColor(hexString: "#875C3A").withAlphaComponent(0.5)
        polygon.strokeColor = UIColor(hexString: "#875C3A")
        polygon.strokeWidth = 1;
        polygon.isTappable = false
        polygon.map = mapView
    }
    
    func refreshPath() {
        polyGonPath?.removeAllCoordinates()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.viewModel.data.coordinates.count > 2) {
                self.viewModel.data.coordinates.forEach({self.polyGonPath?.add($0)})
                if let polyGonPath = self.polyGonPath {
                    self.polygon.path = polyGonPath
                    if (self.polygon.map == nil) {
                        self.polygon.map = self.mapView
                    }
                }
                
            } else {
                if let polyGonPath = self.polyGonPath{
                    self.polygon.path = polyGonPath
                    self.polygon.map = nil
                }
            }
        }
    }
    
}
extension AddZoneViewController : GMSMapViewDelegate  {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        LocationManager.getCityAndStateCountry(lat: position.target.latitude, long: position.target.longitude) { string in
            if(!self.isInitalLoad) {
                self.txtFieldSearch.text = string
            }
            self.isInitalLoad = false
        }
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if (isForView) {
            return
        }
        LocationManager.sharedInstance.reverseGeocodeCoordinate(coordinate) { address ,cityName in
            let marker = GMSMarker(position: coordinate)
            let size: CGFloat = 10
            UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0.0)
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.setFillColor(UIColor.systemOrange.cgColor) // customize color
            ctx.fillEllipse(in: CGRect(x: 0, y: 0, width: size, height: size))
            let circleImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            marker.icon = circleImage
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = self.mapView
            self.markers.append(marker)
            
            
            self.btnUndu.isHidden = false
            self.viewModel.setLocation(coordinate)
            self.refreshPath()
        }
        
    }
    
}

//MARK: UITextFieldDelegate Methods
extension AddZoneViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if string.isEmpty {
            return true
        }
        var newText = textField.text ?? ""
        newText = string.isEmpty ? String(newText.dropLast()) : newText + string
        if (textField == self.txtFieldNameArabic) {
            // Define the set of English letters to block
            if currentText.hasPrefix(" "){
                return false
            }
            let englishLetters = CharacterSet.lowercaseLetters.union(CharacterSet.uppercaseLetters)
            
            // Check if the replacement string contains any English letters
            if string.rangeOfCharacter(from: englishLetters) != nil {
                self.showAlert(msg: "Plese enter arabic letter.")
                return false
            }
        } else if (textField == self.txtFieldNameEnglish) {
            if currentText.hasPrefix(" "){
                return false
            }
        }
        
        if let data = validation {
            return data.validate()
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldSearch {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            autocompleteController.modalPresentationStyle = .overFullScreen
            self.present(autocompleteController, animated: true, completion: nil)
            self.txtFieldSearch.resignFirstResponder()
        }
    }
}
extension AddZoneViewController : GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        LocationManager.getCityAndStateCountry(lat: place.coordinate.latitude, long: place.coordinate.longitude) { string in
            self.mapView.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoom: 16.0))
            self.viewModel.setLocation(place.coordinate)
            LocationManager.sharedInstance.reverseGeocodeCoordinate(place.coordinate) { address ,cityName in
                if (cityName.lowercased() == String.getString(self.viewModel.cityInfo?.name)) {
                    
                }
            }
            viewController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
