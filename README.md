# Parseoid

<img src="/app/assets/images/logo.svg" height="200px"/>

[Demo](https://parseoid.onrender.com/) _(hosted on free tier and relaunching might take some time)_

The assignment entails developing a feature for dynamically adjusting dates within text lines of templates. This includes parsing and modifying date variables (**#d#** for day, **#m#** for month, **#y#** for year) based on a given reference date, allowing both arithmetic operations and various formats.

### Specific Rules:
- **#d#** - day of the given reference date
- **#m#** - month number of the given reference date
- **#y#** - full year of the given reference date (e.g., 2021)

You can add or subtract numbers from these variables to adjust the date in the text line relative to the given reference date.

**Example:** If the reference date is March 1, 2021, and the text format is **#d-1#. #m+1#. #y+1#**, the resulting date will be March 31, 2022 as 31. 03. 2022. (Czech date format is used in the demo)

### Guidelines:
- The date in the text is optional; it can appear once or multiple times.
- Dates can be located anywhere within the text.
- The date might not be complete, containing only some variables (e.g., just the month and year or just the day and month).
- All dates may include added or subtracted numbers and must be evaluated independently.
- Dates can have different formats and separators.
- Only numeric values for months are required; month names are not needed.
- No additional control characters should be used.

## Quickstart

The application is based on [Ruby on Rails](https://rubyonrails.org/) framework. It uses only seweral parts of it without need to run the whole Rails stack including database, redis, and so on. So you can run it locally by following these steps:

### Code

The parser, tokenizer, and token implementation are located in the `lib` directory. The main parser is in `lib/lib/date_variable_parser/date_parser.rb`, the tokenizer is in `lib/lib/date_variable_parser/date_tokenizer.rb`, and the token implementation is in `lib/token.rb`. The parser is used in the `app/controllers/parser_controller.rb` controller.

This first implementation is not perfect and has some limitations, but it was completed in a short time and the solution meets all the original requirements. The parser is not able to handle more complex invalid placeholders.

### Prerequisites

- Ruby 3.3.1 (not tested with older Ruby 3.x versions)

### Running the application

1. Clone the repository

    ```bash
    git clone https://github.com/deepj/parseoid.git
    ```

2. Install dependencies using Bundler

   ```
   bundle install
   ```
3. Start the server

   ```
   bin/rails server
   ```

4. Open your browser and navigate to [http://localhost:3000](http://localhost:3000) or just click on the link here.

### Running the tests

The application uses default Rails testing framework based on [Minitest](https://guides.rubyonrails.org/testing.html). You can run the tests by executing the following command:

```bash
bin/rails test
```
For system tests

```bash
bin/rails test:system
```

## Deployment

The application is deployed on [Render](https://render.com). The deployment is done automatically on every push to the master branch if CI workflow passes. The CI workflow is defined in ./.github/workflows/ci.yml. The currently is no option to make a deploy on Render manually from a terminal.

## Useful links

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Hotwire: HTML Over The Wire](https://hotwired.dev/)
- [Brewing our own Template Lexer in Ruby](https://blog.appsignal.com/2019/07/02/ruby-magic-brewing-our-own-template-lexer-in-ruby.html)
- [stimulus-live-elements](https://github.com/superfly/stimulus-live-elements?tab=readme-ov-file)
