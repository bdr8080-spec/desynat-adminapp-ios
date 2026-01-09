//
//  LiveRequestListManagementViewController.swift
//  DesynatAdmin
//
//  Created by fluper on 06/01/26.
//

import UIKit
import FSCalendar

class LiveRequestListManagementViewController: UIViewController {
  
  @IBOutlet weak var liveRequestTbleViewHieghtConstarint: NSLayoutConstraint!
  @IBOutlet weak var noLiveRequestDataFoundLabel: UILabel!
  @IBOutlet weak var noLiveRequestTimeSlotFoundLabel: UILabel!
  @IBOutlet weak var liveRequestTimeSlotTableViewHieghtConstriant: NSLayoutConstraint!
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
  @IBOutlet weak var searchView: CustomView!
  @IBOutlet weak var searchSpaceLabel: UILabel!
  @IBOutlet weak var selectedTabbarStackView: UIStackView!
  @IBOutlet weak var customCalenderParentView: CustomView!
  @IBOutlet weak var allLabel: UILabel!
  @IBOutlet weak var allBottomLabel: UILabel!
  @IBOutlet weak var approvedLabel: UILabel!
  @IBOutlet weak var approvedBottomLabel: UILabel!
  @IBOutlet weak var rejectedLabel: UILabel!
  @IBOutlet weak var rejectedBottomLabel: UILabel!
  @IBOutlet weak var liveREquestTableView: TableViewDynamicHeight! {
    didSet {
      liveREquestTableView.registerCellFromNib(cellID: "LiveRequestTimingTableViewCell")
    }
  }
  
  @IBOutlet weak var searchTF: BindableTextField!
  @IBOutlet weak var dateLabelInCustomCalender: UILabel!
  @IBOutlet weak var assignButtonView: UIView!
  @IBOutlet weak var liveRequestTimeSlotLabel: UILabel!
  @IBOutlet weak var paginationBottomView: UIView!
  @IBOutlet weak var lblPageCount: UILabel!
  @IBOutlet weak var btnPreviousPage: UIButton!
  @IBOutlet weak var btnNextPage: UIButton!
  
  private var searchWorkItem: DispatchWorkItem?
  var liveRequestTimeslotISSelcted: Bool = true
  var selectedTab: SelectedLiveRequestTab = .new
  private lazy var viewModel = LiveRequestListManagementViewModel(hostVC: self)
  var selectedCountryIndex: Int = 0
  var slectedLiveRequestType: Int = 1
  var selectedDateString: String? = ""
  lazy private var monthYearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"   // November 2025
    return formatter
  }()
  private lazy var apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
  private lazy var selectedDateFormatterForLiveRequestTimeSlot: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyyy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
  private lazy var shortDateFormatterForCalender: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE , MMM d"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTF.delegate = self
    configureCalendar()
    countryDropDownView.isHidden = true
    selectedCountryView.isHidden = false
    viewModel.getAllCountry()
    initialUIStep(isShow: true)
    slectedLiveRequestType = 1
    liveRequestTbleViewHieghtConstarint.constant = 0
    
  }
  
  //  override func viewWillAppear(_ animated: Bool) {
  //    super.viewWillAppear(animated)
  //    viewModel.getAllTimeRequestTimeSlot()
  //  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    DispatchQueue.main.async {
      self.countryTableViewHeightConstarint.constant = self.countryTableView.contentSize.height
      //        self.liveRequestTimeSlotTableViewHieghtConstriant.constant = self.timeSlotsTableView.contentSize.height
    }
  }
  
  @IBAction func liveRequestTimeSlotDidTapped(_ sender: Any) {
    liveReuqestTimeButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    liveRequestTimeLabel.textColor = .white
    liveRequestLabel.textColor = .black
    liveRequestButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    initialUIStep(isShow: true)
    slectedLiveRequestType = 1
    noLiveRequestDataFoundLabel.isHidden = true
    liveRequestTbleViewHieghtConstarint.constant = 0
  }
  
  @IBAction func liveRequestDidTapped(_ sender: Any) {
    liveReuqestTimeButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    liveRequestTimeLabel.textColor = .black
    liveRequestLabel.textColor = .white
    liveRequestButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    initialUIStep(isShow: false)
    noLiveRequestTimeSlotFoundLabel.isHidden = true
    liveRequestTimeSlotTableViewHieghtConstriant.constant = 0
    slectedLiveRequestType = 2
    viewModel.currentPage = 1
    viewModel.getLiveRequest()
    updatePaginationButtonImages()
  }
  
  @IBAction func chooseCountryDidTapepd(_ sender: Any) {
    if liveRequestTimeslotISSelcted {
      
    }
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
    nextVC.selectedDate = selectedDateString ?? ""
    nextVC.countryId = selectedCountryIndex
    nextVC.isComingForEdit = false
    self.navigationController?.present(nextVC, animated: true)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  @IBAction func allDidTapped(_ sender: Any) {
    selectedTab = .new
    updateTabUI()
    viewModel.currentPage = 1
    searchTF.text = ""
    viewModel.getLiveRequest()
  }
  
  
  @IBAction func approvedDidTapped(_ sender: Any) {
    selectedTab = .approved
    updateTabUI()
    viewModel.currentPage = 1
    searchTF.text = ""
    viewModel.getLiveRequest()
  }
  
  
  @IBAction func rejectedDidTapped(_ sender: Any) {
    selectedTab = .rejected
    updateTabUI()
    viewModel.currentPage = 1
    searchTF.text = ""
    viewModel.getLiveRequest()
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = PromocodeFilterViewController.instantiate(fromAppStoryboard: .ShippingPromocode)
    //       vc.selectedFilter = viewModel.appliedFilter
    //       vc.onApplyFilter = { [weak self] filter in
    //           guard let self = self else { return }
    //           self.viewModel.appliedFilter = filter
    //           self.viewModel.currentPage = 1
    //           self.viewModel.getAllPromocode()
    //       }
    //       vc.onClearFilter = { [weak self] in
    //           guard let self = self else { return }
    //           self.viewModel.appliedFilter = UserFilterModel()
    //           self.viewModel.currentPage = 1
    //           self.viewModel.getAllPromocode()
    //       }
    self.navigationController?.present(vc, animated: true)
  }
  
  @IBAction func handleNextPage(_ sender: UIButton) {
    viewModel.goToNextPage()
  }
  
  @IBAction func handlePreviousPage(_ sender: UIButton) {
    viewModel.goToPreviousPage()
  }
  
  private func refreshPageActionButton() {
    //    self.btnNextPage.setImage(self.viewModel.isLastPage ? .lightnextimage : .nextRight, for: .normal)
    //    self.btnNextPage.isUserInteractionEnabled = !self.viewModel.isLastPage
    //    self.btnPreviousPage.setImage(self.viewModel.isFirstPage ? .previousLeft : .darkpreviousimage, for: .normal)
    //    self.btnPreviousPage.isUserInteractionEnabled = !self.viewModel.isFirstPage
    //    self.lblPageCount.text = "\(self.viewModel.currentPage < 10 ? "0" : "")\(self.viewModel.currentPage) of \(self.viewModel.totalPage < 10 ? "0" : "")\(self.viewModel.totalPage)"
  }
  
  func updateTimeSlotTableHeight() {
    timeSlotsTableView.layoutIfNeeded()
    if !viewModel.slectedTimeSlot.isEmpty {
      liveRequestTimeSlotTableViewHieghtConstriant.constant = timeSlotsTableView.contentSize.height
    } else {
      liveRequestTimeSlotTableViewHieghtConstriant.constant = 150
    }
    
  }
  
  func updateLiveRequestTableHeight() {
    liveREquestTableView.layoutIfNeeded()
    if !viewModel.LiveRequestList.isEmpty {
      liveRequestTbleViewHieghtConstarint.constant = 600//liveREquestTableView.contentSize.height
    } else {
      liveRequestTbleViewHieghtConstarint.constant = 250
    }
    
  }
  
  func updateTabUI() {
    allLabel.textColor = selectedTab == .new ? .darkBrown : UIColor(hexString: "#C0BBBB")
    allBottomLabel.backgroundColor = selectedTab == .new ? .darkBrown : UIColor(hexString: "#C0BBBB")
    
    approvedLabel.textColor = selectedTab == .approved ? .darkBrown : UIColor(hexString: "#C0BBBB")
    approvedBottomLabel.backgroundColor = selectedTab == .approved ? .darkBrown : UIColor(hexString: "#C0BBBB")
    
    rejectedLabel.textColor = selectedTab == .rejected ? .darkBrown : UIColor(hexString: "#C0BBBB")
    rejectedBottomLabel.backgroundColor = selectedTab == .rejected ? .darkBrown : UIColor(hexString: "#C0BBBB")
  }
  
  func initialUIStep(isShow: Bool) {
    searchView.isHidden = isShow
    searchSpaceLabel.isHidden = isShow
    selectedTabbarStackView.isHidden = isShow
    customCalenderParentView.isHidden = !isShow
    liveREquestTableView.isHidden = isShow
    liveRequestTimeSlotLabel.isHidden = !isShow
    timeSlotsTableView.isHidden = !isShow
    assignButtonView.isHidden = !isShow
    paginationBottomView.isHidden = isShow
    
    // IMPORTANT
    //    if !isShow {
    //        noLiveRequestTimeSlotFoundLabel.isHidden = true
    //    }
    
    liveRequestTimeslotISSelcted = isShow
    
    if isShow {
      selectTodayDate()
    }
  }
  
  
  private func updateSelectedDateLabel(date: Date) {
    let calendar = Calendar.current
    let formattedDate = selectedDateFormatterForLiveRequestTimeSlot.string(from: date)
    if calendar.isDateInToday(date) {
      liveRequestTimeSlotLabel.text = "Today, \(formattedDate)"
    } else {
      liveRequestTimeSlotLabel.text = formattedDate
    }
    dateLabelInCustomCalender.text = shortDateFormatterForCalender.string(from: date)
  }
  
  
  private func selectTodayDate() {
    let today = Calendar.current.startOfDay(for: Date())
    viewCalendar.select(today)
    viewCalendar.setCurrentPage(today, animated: false)
    dateAndYearLabel.text = monthYearFormatter.string(from: today)
    
    selectedDateString = apiDateFormatter.string(from: today)
    updateSelectedDateLabel(date: today)
    // Fetch with default date + country
    viewModel.fetchTimeSlotsIfPossible()
    
  }
  
  
  
  private func configureCalendar() {
    viewCalendar.delegate = self
    viewCalendar.dataSource = self
    
    // Register custom gradient cell
    viewCalendar.register(
      GradientCalendarCell.self,
      forCellReuseIdentifier: "GradientCalendarCell"
    )
    
    // Disable default selection color
    viewCalendar.appearance.selectionColor = .clear
    viewCalendar.appearance.titleSelectionColor = .white
    
    viewCalendar.appearance.todayColor = .clear
    viewCalendar.appearance.titleTodayColor = .black
    
    viewCalendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    viewCalendar.appearance.weekdayTextColor = .black
    viewCalendar.appearance.headerTitleColor = .black
    viewCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    viewCalendar.appearance.caseOptions = [.weekdayUsesSingleUpperCase]
    
    viewCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
    viewCalendar.headerHeight = 0
    
    dateAndYearLabel.text = monthYearFormatter.string(from: viewCalendar.currentPage)
  }
  
  private func toggleReasonStatus(at indexPath: IndexPath) {
    var category = viewModel.slectedTimeSlot[indexPath.row]
    let newStatus = category.status == 1 ? 0 : 1
    let params: [String: Any] = ["timeslot_id": category.id ?? 0]
    viewModel.updateActiveStatus(param: params) { [weak self] success in
      guard let self = self else { return }
      if success {
        category.status = newStatus
        self.viewModel.slectedTimeSlot[indexPath.row] = category
        self.timeSlotsTableView.reloadRows(at: [indexPath], with: .automatic)
        if let status = category.status {
          if status == 1 {
            CommonUtils.showToast(message: "Live Request Timeslot Unblocked Succesfully")
          } else {
            CommonUtils.showToast(message: "Live Request Timeslot Blocked Succesfully")
          }
        }
      }
    }
  }
  
  func updatePaginationButtonImages() {
    // Previous Button
    if viewModel.currentPage == 1 {
      btnPreviousPage.setImage(UIImage(named: "previousLeft"), for: .normal)
      btnPreviousPage.isUserInteractionEnabled = false
    } else {
      btnPreviousPage.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
      btnPreviousPage.isUserInteractionEnabled = true
    }
    
    // Next Button
    if viewModel.currentPage >= viewModel.totalPages {
      btnNextPage.setImage(UIImage(named: "lightnextimage"), for: .normal)
      btnNextPage.isUserInteractionEnabled = false
    } else {
      btnNextPage.setImage(UIImage(named: "nextRight"), for: .normal)
      btnNextPage.isUserInteractionEnabled = true
    }
  }
  
}

extension LiveRequestListManagementViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == liveREquestTableView {
      return viewModel.LiveRequestList.count
    } else if tableView == countryTableView {
      return viewModel.countryListData.count
    } else {
      return viewModel.slectedTimeSlot.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == liveREquestTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRequestTimingTableViewCell", for: indexPath) as! LiveRequestTimingTableViewCell
      let data = viewModel.LiveRequestList[indexPath.row]
      cell.configData(data: data)
      cell.buttonStackView.isHidden = (selectedTab != .new)
      cell.onAcceptTap = {
        let param: [String: Any] = ["request_id": data.id ?? 0]
        self.viewModel.acceptRequest(param: param)
      }
    
      cell.onRejectTap = {
        let vc = RejectReasonViewController.viewFromNIB
        vc.needToShowButtonStackView = true
        vc.setCallback { reason,type in
          let param: [String: Any] = ["request_id": data.id ?? 0,
                                      "reject_reason": reason]
          self.viewModel.rejectLiveRequest(param: param)
        }
        self.presentVC(vc,withAnimation: false,modalPresentationStyle: .overCurrentContext)
      }
      
      return cell
    } else if tableView == countryTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
      let data = viewModel.countryListData[indexPath.row]
      cell.configData(data: data,isSelected: indexPath.row == selectedCountryIndex)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LiveRequestListViewCell", for: indexPath) as! LiveRequestListViewCell
      let data = viewModel.slectedTimeSlot[indexPath.row]
      cell.configData(data: data)
      cell.onEditToggle = {
        let nextVC = AddTimeSlotViewController.instantiate(fromAppStoryboard: .LiveStoryDealManagement)
        nextVC.slectedTimeSlot = data
        nextVC.isComingForEdit = true
        nextVC.countryId = self.selectedCountryIndex
        nextVC.selectedDate = self.selectedDateString ?? ""
        nextVC.onChangesDone = {
          self.viewModel.fetchTimeSlotsIfPossible()
        }
        self.navigationController?.present(nextVC, animated: true)
      }
      
      cell.onDeleteToggle = {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this timeslot?") { [weak self] in
          guard let self = self else { return }
          let param: [String: Any] = ["timeslot_id": data.id ?? ""]
          viewModel.deleteTimeSlots(param: param)
        }
      }
      
      cell.onStatusToggle = {
        self.toggleReasonStatus(at: indexPath)
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView == liveREquestTableView {
      
    }else if tableView == countryTableView {
      //      selectedCountryIndex = indexPath.row
      //      let data = viewModel.countryListData[indexPath.row]
      //      dropdownCountryLabel.text = data.name
      //      dropDownCountryFlagEmoji.text = data.flag
      //      selectedCountryLabel.text = data.name
      //      countryTableView.reloadData()
      //      selectedCountryView.isHidden = false
      //      countryDropDownView.isHidden = true
      
      let data = viewModel.countryListData[indexPath.row]
      selectedCountryIndex = data.id ?? 0
      dropdownCountryLabel.text = data.name
      dropDownCountryFlagEmoji.text = data.flag
      selectedCountryLabel.text = data.name
      
      countryTableView.reloadData()
      selectedCountryView.isHidden = false
      countryDropDownView.isHidden = true
      
      // REFRESH API ON COUNTRY CHANGE
      if slectedLiveRequestType == 1 {
        viewModel.fetchTimeSlotsIfPossible()
      } else {
        viewModel.getLiveRequest()
      }
    } else {
      
    }
  }
  
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    return 65
  //  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if tableView == countryTableView {
      viewWillLayoutSubviews()
    }
  }
  
}

extension LiveRequestListManagementViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    let today = Calendar.current.startOfDay(for: Date())
    let targetDate = Calendar.current.startOfDay(for: date)
    return targetDate >= today
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    let today = Calendar.current.startOfDay(for: Date())
    let targetDate = Calendar.current.startOfDay(for: date)
    guard targetDate >= today else { return }
    selectedDateString = apiDateFormatter.string(from: targetDate)
    updateSelectedDateLabel(date: targetDate)
    viewModel.fetchTimeSlotsIfPossible()
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
      return .black
    }
    return .black
  }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    dateAndYearLabel.text = monthYearFormatter.string(from: calendar.currentPage)
  }
  
  func calendar(_ calendar: FSCalendar,cellFor date: Date,at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "GradientCalendarCell",for: date, at: position) as! GradientCalendarCell
    return cell
  }
  
}

extension LiveRequestListManagementViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
      self.viewModel.searchText = currentText
      self.viewModel.currentPage = 1
      self.viewModel.getLiveRequest()
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}



enum SelectedLiveRequestTab: Int {
  case new = 0        // new
  case approved = 1   // accepted
  case rejected = 2   // rejected
}
