# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                       :bigint           not null, primary key
#  amount                   :float(24)
#  currency                 :string(255)
#  description              :string(255)
#  payment_link             :string(255)
#  razorpay_signature       :string(255)
#  status                   :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  product_price_id         :integer
#  razorpay_order_id        :string(255)
#  razorpay_payment_id      :string(255)
#  razorpay_payment_link_id :string(255)
#  user_id                  :integer
#
class Order < ApplicationRecord
  has_one :product_price

  def self.determine_succession_order(order)
    return unless order.status == 'Paid'

    product_price = ProductPrice.find_by(id: order.product_price_id)
    return if product_price.blank?

    if product_price.product_type == 'College Application'
      college_student = CollegeStudent.find_by(user_id: order.user_id)
      college_student.update(state: 5) if college_student.present?
    elsif product_price.product_type == 'Course'
      puts "Course Fee Paid for user: #{order.user_id} #{product_price.product_name}"

      product_price.product_id.each do |course_module_id|
        puts "Adding Course: #{course_module_id} for user: #{order.user_id}"
        course_module = CourseModule.find_by(id: course_module_id)

        if course_module&.persisted?
          access = CourseModuleAccess.find_or_create_by(course_module_id: course_module_id, accessor_id: order.user_id, accessor_type: 'User', status: 'granted')
          puts "Added Course: #{course_module.id} for user: #{order.user_id}"
        end
      end
    end
  end
end
