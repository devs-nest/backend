# frozen_string_literal: true

HEADERS = {
  'ACCEPT' => 'application/vnd.api+json',
  'CONTENT-TYPE' => 'application/vnd.api+json'

}

USER_SPEC_PARAMS = {
  "data": {
    "type": 'onboards',
    "attributes": {
      "discord_username": 'KayDee#8576',
      "discord_id": '1234567890',
      "name": 'KayDee',
      "college_name": 'TestGrp',
      "grad_year": 2,
      "work_exp": '2mnth',
      "known_from": 'Friend',
      "dsa_skill": 4,
      "webd_skill": 3,
      "is_discord_form_filled": true
    }
  }
}.freeze
