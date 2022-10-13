# frozen_string_literal: true

# == Schema Information
#
# Table name: markdowns
#
#  id       :bigint           not null, primary key
#  template :text(65535)
#
class Markdown < ApplicationRecord
  before_save :template_encode
  def template_encode
    self.template = template.dup.force_encoding('ISO-8859-1').encode('UTF-8') unless template.blank?
  end
end
