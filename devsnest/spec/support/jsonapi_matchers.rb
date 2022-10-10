# frozen_string_literal: true

RSpec::Matchers.define :be_jsonapi_response_for do |model|
  match do |response|
    body = JSON.parse(response.body, symbolize_names: true)
    response.content_type == 'application/vnd.api+json' &&
      body.dig(:data, :type).to_sym == model &&
      body.dig(:data, :attributes).is_a?(Hash)
  end
end

RSpec::Matchers.define :have_attribute do |attr|
  match do |actual|
    (actual[:attributes] || {}).key?(attr) &&
      (!@val_set || actual[:attributes][attr] == @val)
  end

  chain :with_value do |val|
    @val_set = true
    @val = val
  end
end

RSpec::Matchers.define :have_attributes do |*attrs|
  match do |actual|
    return false unless actual.key?(:attributes)

    attrs.all? { |attr| actual[:attributes].key?(attr) }
  end
end
