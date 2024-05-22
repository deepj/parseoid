# frozen_string_literal: true

class ParserHelperTest < ActionView::TestCase
  test "parses date from params" do
    date = date_from_param("2024-03-28")

    assert_equal Date.new(2024, 3, 28), date
  end

  test "parser returns nil for invalid params" do
    assert_nil date_from_param("invalid")
    assert_nil date_from_param("")
    assert_nil date_from_param("2024-13-28")
  end

  test "renders date template" do
    date = Date.new(2024, 3, 28)
    template = "Company for the period from #d-2#. #m-1#. #y-1# to #d-3#. #m+1#. #y+1#"

    result = render_date_template(template, date)

    assert_equal "Company for the period from 26. 2. 2023 to 25. 4. 2025", result
  end

  test "renders date template, when no date is provided, using current date" do
    travel_to Date.new(2024, 5, 1) do
      template = "Company for the period from #d-2#. #m-1#. #y-1# to #d-3#. #m+1#. #y+1#"
      result = render_date_template(template, "")
      assert_equal "Company for the period from 30. 3. 2023 to 29. 5. 2025", result
    end

    travel_to Date.new(2024, 6, 1) do
      template = "Company for the period from #d-2#. #m-1#. #y-1# to #d-3#. #m+1#. #y+1#"
      result = render_date_template(template, nil)
      assert_equal "Company for the period from 29. 4. 2023 to 28. 6. 2025", result
    end
  end
end
