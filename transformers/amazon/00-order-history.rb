#!/usr/bin/env ruby

require 'csv'

tOrders = {}
input = CSV.new(ARGF.file, headers: true, liberal_parsing: true, encoding: "bom|utf-8")

CSV do |output|
  output << ["date", "order id", "subtotal", "tax", "total"]
  input.each do |row|
    date     = Date.parse(row["Order Date"])
    orderId  = row["Order ID"]
    orderSub = row["Shipment Item Subtotal"]
    orderTax = row["Shipment Item Subtotal Tax"]

    next if orderSub == 'Not Available' || orderTax == 'Not Available' 
    next if tOrders[orderId]
    tOrders[orderId] = true

    orderSub = orderSub.gsub(",", "").to_i
    orderTax = orderTax.gsub(",", "").to_i
    total = orderSub + orderTax


    output << [date, orderId, orderSub, orderTax, total]
  end
end