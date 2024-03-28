# frozen_string_literal: true

require "application_system_test_case"

class UserParsingTest < ApplicationSystemTestCase
  test "parser interprets date variables correctly" do
    visit root_url # Nahraďte root_url skutečnou cestou k vaší testované stránce

    fill_in "date", with: "2024-03-28"
    fill_in "content", with: "Company for the period from #d-2#. #m-1#. #y-1# to #d-3#. #m+1#. #y+1#"

    assert_text "Company for the period from 26. 2. 2023 to 25. 4. 2025"
  end
end
