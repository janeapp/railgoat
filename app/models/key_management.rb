# frozen_string_literal: true
class KeyManagement < ApplicationRecord
  belongs_to :work_info
  belongs_to :user

  work_info.each do |wi|
    list = [:user_id, :SSN]
    info = WorkInfo.new(wi.reject {|k| list.include?(k)})
    info.user_id = wi[:user_id]
    info.build_key_management({:user_id => wi[:user_id], :iv => SecureRandom.hex(32) })
    info.SSN = wi[:SSN]
    info.save
  end
end
