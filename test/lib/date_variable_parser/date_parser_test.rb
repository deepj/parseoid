# frozen_string_literal: true

require "test_helper"

module DateVariableParser
  class DateParserTest < ActiveSupport::TestCase
    BASIC_TEST_CASES = [
      {
        description: "empty input",
        input: "",
        date: "2021-03-03",
        expected: ""
      },
      {
        description: "date variables only",
        input: "#y# #m# #d#",
        date: "2023-08-07",
        expected: "2023 8 7"
      },
      {
        description: "static text without date variables",
        input: "We are billing you for legal services",
        date: "2021-03-03",
        expected: "We are billing you for legal services"
      },
      {
        description: "simple date variable replacement",
        input: "#d#. #m#. #y#",
        date: "2021-03-03",
        expected: "3. 3. 2021"
      },
      {
        description: "date variables within a sentence",
        input: "Staff training #d#. #m#. #y#",
        date: "2021-03-20",
        expected: "Staff training 20. 3. 2021"
      },
      {
        description: "date variables with custom format",
        input: "Staff training #m#/#d#/#y#",
        date: "2021-03-20",
        expected: "Staff training 3/20/2021"
      },
      {
        description: "full date in reverse format with surrounding text",
        input: "Staff training on #y#-#m#-#d# and preparation of materials",
        date: "2021-03-20",
        expected: "Staff training on 2021-3-20 and preparation of materials"
      },
      {
        description: "partial date with day and month",
        input: "Staff training on #d#. #m#. and preparation of materials",
        date: "2021-03-20",
        expected: "Staff training on 20. 3. and preparation of materials"
      }
    ]

    ARITHEMTIC_MANIPULATIONS_CASES = [
      {
        description: "month arithmetic, showing previous month and year",
        input: "Garage rental for month #m-1#/#y#",
        date: "2021-08-01",
        expected: "Garage rental for month 7/2021"
      },
      {
        description: "large month subtraction, showing previous year",
        input: "Very old car accident on #d#. #m#. #y-100#",
        date: "2024-03-28",
        expected: "Very old car accident on 28. 3. 1924"
      },
      {
        description: "arithmetic resulting in negative month",
        input: "Last meeting minutes from #m-13#/#y-1#",
        date: "2023-02-10",
        expected: "Last meeting minutes from 1/2021"
      },
      {
        description: "date arithmetic across year boundary",
        input: "Invoice for period #d#. #m-1#. #y# - #d#. #m+1#. #y#",
        date: "2023-01-15",
        expected: "Invoice for period 15. 12. 2022 - 15. 2. 2023"
      },
      {
        description: "date arithmetic with large values",
        input: "Expiration date: #d#. #m#. #y+100#",
        date: "2023-06-12",
        expected: "Expiration date: 12. 6. 2123"
      },
      {
        description: "multiple arithmetic operations",
        input: "Maintenance scheduled for #y+1#-#m+6#-#d-14#",
        date: "2023-03-20",
        expected: "Maintenance scheduled for 2024-9-6"
      }
    ]

    COMPLEX_AND_RANGES_CASES = [
      {
        description: "complex date range with month addition over a year",
        input: "Corporate rate for the period #d#. #m#. #y# to #d-1#. #m+12#. #y#",
        date: "2020-02-15",
        expected: "Corporate rate for the period 15. 2. 2020 to 14. 2. 2021"
      },
      {
        description: "date range with month increment across year boundary",
        input: "Corporate rate for the period #d#. #m#. #y# to #d-1#. #m+1#. #y#",
        date: "2020-12-21",
        expected: "Corporate rate for the period 21. 12. 2020 to 20. 1. 2021"
      },
      {
        description: "date range within a single month",
        input: "Corporate rate for the period #d#. #m#. #y# to #d-1#. #m+1#. #y#",
        date: "2020-03-01",
        expected: "Corporate rate for the period 1. 3. 2020 to 31. 3. 2020"
      },
      {
        description: "complex date range spanning multiple months across years",
        input: "Corporate rate for the period #d#. #m#. #y# - #d-1#. #m+3#. #y#",
        date: "2021-12-01",
        expected: "Corporate rate for the period 1. 12. 2021 - 28. 2. 2022"
      },
      {
        description: "date range with subtraction on date, month, and year",
        input: "Corporate rate for the period #d#. #m-3#. #y# to #d-1#. #m#. #y#",
        date: "2021-01-17",
        expected: "Corporate rate for the period 17. 10. 2020 to 16. 1. 2021"
      },
      {
        description: "date range with year decrement",
        input: "Corporate rate for the period #d#. #m#. #y-1# to #d-1#. #m#. #y#",
        date: "2022-04-24",
        expected: "Corporate rate for the period 24. 4. 2021 to 23. 4. 2022"
      },
      {
        description: "consecutive day range with month increment",
        input: "Corporate rate for the period #d-2#. - #d-3#. #m+1#. #y#",
        date: "2022-04-03",
        expected: "Corporate rate for the period 1. - 30. 4. 2022"
      },
      {
        description: "extended date range with operations on day, month, and year",
        input: "Corporate rate for the period from #d-2#. #m-1#. #y-1# to #d-3#. #m+1#. #y+1#",
        date: "2022-04-03",
        expected: "Corporate rate for the period from 1. 3. 2021 to 30. 4. 2023"
      },
      {
        description: "multiple date variables in a sentence",
        input: "Meeting scheduled for #d#. #m#. #y# at #d+1#. #m#. #y#",
        date: "2023-05-15",
        expected: "Meeting scheduled for 15. 5. 2023 at 16. 5. 2023"
      },
      {
        description: "date range with leading zeros",
        input: "Report covers period from #d#.#m#.#y# to #d#.#m+1#.#y#",
        date: "2024-09-03",
        expected: "Report covers period from 3.9.2024 to 3.10.2024"
      },
      {
        description: "date range with day and month addition",
        input: "Schedule for #d+5#. #m#. - #d+10#. #m+1#. #y#",
        date: "2023-11-25",
        expected: "Schedule for 30. 11. - 4. 1. 2024"
      },
      {
        description: "date formatting with leading zeros",
        input: "Appointment scheduled for #d#/#m#/#y#",
        date: "2023-01-05",
        expected: "Appointment scheduled for 5/1/2023"
      }
    ]

    INVALID_DATE_VARIABLES_CASES = [
      {
        description: "invalid date variable",
        input: "Invoice issued on #x#.",
        date: "2023-09-03",
        expected: "Invoice issued on #x#."
      },
      {
        description: "invalid date variable with arithmetic",
        input: "Expire items on #d+.",
        date: "2024-11-12",
        expected: "Expire items on #d+."
      },
      {
        description: "invalid date variable with arithmetic and text",
        date: "2030-01-01",
        input: "Food stamps issued on #y+r#.",
        expected: "Food stamps issued on #y+r#."
      },
      {
        description: "invalid date variable with arithmetic and invalid date variable",
        date: "2022-11-09",
        input: "Book is reserved #y#-#m#, ordered at #y#-#m#-#d#. Book of ##y",
        expected: "Book is reserved 2022-11, ordered at 2022-11-9. Book of ##y"
      },
      # {
      #   description: "invalid date variable with missing hash",
      #   input: "Expiration date: d#. #m#. #y#",
      #   date: "2023-09-03",
      #   expected: "Expiration date: d#. 9. 2023"
      # },
      # {
      #   description: "invalid date variable with missing number",
      #   input: "Effective from #d#. #m#. #y# until #d#. #m#. #",
      #   date: "2023-11-01",
      #   expected: "Effective from 1. 11. 2023 until 1. 11. #"
      # },
      # {
      #   description: "invalid arithmetic operation",
      #   input: "Next meeting on #d#. #m2#. #y#",
      #   date: "2023-04-15",
      #   expected: "Next meeting on 15. #m2#. 2023"
      # },
      {
        description: "mixing valid and invalid date variables",
        input: "Received on #d#. #x#. #y# and shipped on #d+1#. #m#. #y#",
        date: "2023-07-20",
        expected: "Received on 20. #x#. 2023 and shipped on 21. 7. 2023"
      }
    ]

    OTHER_CASES = [
      {
        description: "book reservation and order dates",
        input: "Book is reserved #y#-#m#, ordered at #y#-#m#-#d#.",
        date: "2021-03-03",
        expected: "Book is reserved 2021-3, ordered at 2021-3-3."
      },
      {
        description: "date with ordinal suffix",
        input: "Reminder: Meeting on #d#th of #m#, #y#",
        date: "2022-06-01",
        expected: "Reminder: Meeting on 1th of 6, 2022"
      }
    ]

    setup do
      @parser = DateParser.new
    end

    (BASIC_TEST_CASES + ARITHEMTIC_MANIPULATIONS_CASES + COMPLEX_AND_RANGES_CASES + INVALID_DATE_VARIABLES_CASES + OTHER_CASES).each do |test_case|
      test "process #{test_case[:description]}" do
        result = @parser.parse(test_case[:input], Date.parse(test_case[:date]))
        assert_equal test_case[:expected], result
      end
    end
  end
end
