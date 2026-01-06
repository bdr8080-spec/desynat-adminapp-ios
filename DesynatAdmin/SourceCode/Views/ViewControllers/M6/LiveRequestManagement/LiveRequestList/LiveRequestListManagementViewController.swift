//
//  LiveRequestListManagementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import UIKit
import FSCalendar

class LiveRequestListManagementViewController: UIViewController {
  
  @IBOutlet weak var countryTableViewHeightConstarint: NSLayoutConstraint!
  @IBOutlet weak var countryTableView: TableViewDynamicHeight! {
      didSet {
          countryTableView.registerCellFromNib(cellID: "CountryTableViewCell")
      }
  }
  @IBOutlet weak var timeSlotsTableView: UITableView! {
    didSet {
      timeSlotsTableView.registerCellFromNib(cellID: "LiveRequestListViewCell")
    }
  }
  @IBOutlet weak var viewCalendar: FSCalendar!
  @IBOutlet weak var dropdownCountryLabel: CustomLabelFont!
  @IBOutlet weak var countryDropDownView: CustomView!
  @IBOutlet weak var selectedCountryView: CustomView!
  @IBOutlet weak var selectedCountryLabel: CustomLabelFont!
  @IBOutlet weak var dropDownCountryImage: UIImageView!
  @IBOutlet weak var dropDownCountryFlagEmoji: CustomLabelFont!
  @IBOutlet weak var liveRequestTimeLabel: UILabel!
  @IBOutlet weak var liveRequestLabel: UILabel!
  @IBOutlet weak var liveReuqestTimeButtonOutlet: CustomButton!
  @IBOutlet weak var dateAndYearLabel: UILabel!
  @IBOutlet weak var liveRequestButtonOutlet: CustomButton!
  
  private lazy var viewModel = LiveRequestListManagementViewModel(hostVC: self)
  private var selectedCountryIndex: Int = 0
  lazy private var monthYearFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMMM yyyy"   // November 2025
      return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCalendar()
    countryDropDownView.isHidden = true
    selectedCountryView.isHidden = false
    viewModel.getAllCountry()
  }
  
  override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      DispatchQueue.main.async {
          self.countryTableViewHeightConstarint.constant = self.countryTableView.contentSize.height
      }
  }
  
  @IBAction func liveRequestTimeSlotDidTapped(_ sender: Any) {
    liveReuqestTimeButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    liveRequestTimeLabel.textColor = .white
    liveRequestLabel.textColor = .black
    liveRequestButtonOutlet.setImage(UIImage(named: ""), for: .normal)
  }
  
  @IBAction func liveRequestDidTapped(_ sender: Any) {
    liveReuqestTimeButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    liveRequestTimeLabel.textColor = .black
    liveRequestLabel.textColor = .white
    liveRequestButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
  }
  
  
  @IBAction func chooseCountryDidTapepd(_ sender: Any) {
      selectedCountryView.isHidden = true
      countryDropDownView.isHidden = false
  }
  
  @IBAction func selectedCountryDropDownButtonAction(_ sender: Any) {
      selectedCountryView.isHidden = false
      countryDropDownView.isHidden = true
  }
  
  @IBAction func btnCalenderBackTap(_ sender: Any) {
      let currentPage = viewCalendar.currentPage
      let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)
      viewCalendar.setCurrentPage(prevMonth!, animated: true)
  }
  
  @IBAction func btnCalenderFrontTap(_ sender: Any) {
      let currentPage = viewCalendar.currentPage
      let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage)
      viewCalendar.setCurrentPage(nextMonth!, animated: true)
  }
  
  @IBAction func addTimeSlotDidTapped(_ sender: Any) {
    let nextVC = AddTimeSlotViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
    self.navigationController?.present(nextVC, animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func configureCalendar() {
    viewCalendar.delegate = self
    viewCalendar.dataSource = self
    viewCalendar.appearance.selectionColor =  UIColor(hexString: "#6E4527")
    viewCalendar.appearance.titleSelectionColor = .white
    
    viewCalendar.appearance.todayColor = .clear
    viewCalendar.appearance.titleTodayColor = .black
    
    viewCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    viewCalendar.appearance.weekdayTextColor = .black//UIColor(hexString: "#2DA9E1")
    viewCalendar.appearance.headerTitleColor = .black
    viewCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    viewCalendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
    
    viewCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
    viewCalendar.headerHeight = 0
    dateAndYearLabel.text = monthYearFormatter.string(from: viewCalendar.currentPage)

  }
  
  
}

extension LiveRequestListManagementViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == countryTableView {
      return viewModel.countryListData.count
    } else {
      return 3
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == countryTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
      let data = viewModel.countryListData[indexPath.row]
      cell.configData(data: data,isSelected: indexPath.row == selectedCountryIndex)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRequestListViewCell", for: indexPath) as! LiveRequestListViewCell
//      let data = viewModel.countryListData[indexPath.row]
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == countryTableView {
      selectedCountryIndex = indexPath.row
      let data = viewModel.countryListData[indexPath.row]
      dropdownCountryLabel.text = data.name
      dropDownCountryFlagEmoji.text = data.flag
      selectedCountryLabel.text = data.name
      countryTableView.reloadData()
      selectedCountryView.isHidden = false
      countryDropDownView.isHidden = true
    } else {
      
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if tableView == countryTableView {
      viewWillLayoutSubviews()
    }
  }
  
}


extension LiveRequestListManagementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    // Prevent selecting past dates
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        return targetDate >= today
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        
        // Only allow future dates
        guard targetDate >= today else { return }

        
        // Refresh calendar
        calendar.reloadData()
    }


    // Highlight selected range
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        if let start = checkInDate, let end = checkOutDate {
//            if date >= start && date <= end {
//                return UIColor(hexString: "#2DA9E1")
//            }
//        }
        return nil
    }

    // Title color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDate = Calendar.current.startOfDay(for: date)
        
        if targetDate < today {
            return .lightGray
        } else if targetDate >= today {
            return .black.withAlphaComponent(0.5)
        }
        
//        if let start = checkInDate, let end = checkOutDate {
//            if date >= start && date <= end {
//                return .white
//            }
//        }
        
        return .black
    }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      dateAndYearLabel.text = monthYearFormatter.string(from: calendar.currentPage)
  }

  
  

}


