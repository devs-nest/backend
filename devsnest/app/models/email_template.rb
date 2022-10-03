# frozen_string_literal: true

# == Schema Information
#
# Table name: email_templates
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  template_id :string(255)
#
# Indexes
#
#  index_email_templates_on_template_id_and_name  (template_id,name)
#
class EmailTemplate < ApplicationRecord
end
