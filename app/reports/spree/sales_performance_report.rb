module Spree
  class SalesPerformanceReport < Spree::Report
    HEADERS = [:revenue, :tax, :shipping_charges, :refund_amount]

    def self.generate(options = {})
      assign_search_params(options)
      [
        SpreeReportify::ReportDb[:spree_orders___orders].
        exclude(completed_at: nil).
        where(orders__created_at: @start_date..@end_date). #filter by params
        select{[
          Sequel.as(sum(orders__total), :revenue),
          Sequel.as(sum(orders__additional_tax_total) + sum(orders__included_tax_total), :tax),
          Sequel.as(sum(orders__shipment_total), :shipping_charges)
        ]},

        SpreeReportify::ReportDb[:spree_refunds___refunds].
        select{[Sequel.as(sum(:amount), :refund_amount)]}
      ]
    end
  end
end