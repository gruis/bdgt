#!/usr/bin/env ruby

require 'csv'

monthly = Hash.new { |h,i| h[i] = { subtotal: 0, tax: 0, total: 0 } }
input = CSV.new(ARGF.file, headers: true, liberal_parsing: true, encoding: "bom|utf-8")

input.each do |row|
  date      = Date.parse(row["date"])
  subtotal  = row["subtotal"].to_i
  tax       = row["tax"].to_i
  total     = row["total"].to_i
  m = date.month < 10 ? "0#{date.month}" : date.month

  month     = "#{date.year}-#{m}-01"

  monthly[month][:subtotal] = monthly[month][:subtotal] + subtotal
  monthly[month][:tax] = monthly[month][:tax] + tax
  monthly[month][:total] = monthly[month][:total] + total
end

CSV do |output|
  output << ["month", "subtotal", "tax", "total"]
  monthly.each do |month, totals|
    output << [month, totals[:subtotal], totals[:tax], totals[:total]]
  end
end