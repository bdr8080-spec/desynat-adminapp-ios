//
//  HomeDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac2 on 04/05/26.
//

import Foundation

// MARK: - HomeDataModel
struct HomeDataModel: Codable {
    let totalUsers, totalActiveUsers, totalInactiveUsers, totalAffiliateUsers: Int?
    let totalActiveAffiliateUsers, totalInactiveAffiliateUsers, totalSellers, totalActiveSellers: Int?
    let totalInactiveSellers, totalDeliveryBoy, totalActiveDeliveryBoy, totalInactiveDeliveryBoy: Int?
    let totalTickets, totalResolvedTickets, totalUnresolvedTickets, totalOrders: Int?
    let totalOngoingOrders, totalCompletedOrders, totalReturnedOrders, totalCancelledOrders: Int?
    let totalRevenue, totalOrderRevenue, totalSubscriptionPlanRevenue, totalAffiliateOrdersRevenue: String?
    let totalBannerRevenue: String?
    let totalOnlineUsers, totalWebsiteVisitorUsers, totalAppVisitorUsers: Int?

    enum CodingKeys: String, CodingKey {
        case totalUsers = "total_users"
        case totalActiveUsers = "total_active_users"
        case totalInactiveUsers = "total_inactive_users"
        case totalAffiliateUsers = "total_affiliate_users"
        case totalActiveAffiliateUsers = "total_active_affiliate_users"
        case totalInactiveAffiliateUsers = "total_inactive_affiliate_users"
        case totalSellers = "total_sellers"
        case totalActiveSellers = "total_active_sellers"
        case totalInactiveSellers = "total_inactive_sellers"
        case totalDeliveryBoy = "total_delivery_boy"
        case totalActiveDeliveryBoy = "total_active_delivery_boy"
        case totalInactiveDeliveryBoy = "total_inactive_delivery_boy"
        case totalTickets = "total_tickets"
        case totalResolvedTickets = "total_resolved_tickets"
        case totalUnresolvedTickets = "total_unresolved_tickets"
        case totalOrders = "total_orders"
        case totalOngoingOrders = "total_ongoing_orders"
        case totalCompletedOrders = "total_completed_orders"
        case totalReturnedOrders = "total_returned_orders"
        case totalCancelledOrders = "total_cancelled_orders"
        case totalRevenue = "total_revenue"
        case totalOrderRevenue = "total_order_revenue"
        case totalSubscriptionPlanRevenue = "total_subscription_plan_revenue"
        case totalAffiliateOrdersRevenue = "total_affiliate_orders_revenue"
        case totalBannerRevenue = "total_banner_revenue"
        case totalOnlineUsers = "total_online_users"
        case totalWebsiteVisitorUsers = "total_website_visitor_users"
        case totalAppVisitorUsers = "total_app_visitor_users"
    }
}
