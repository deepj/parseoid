# Parseoid

![Parseoid](app/assets/images/parseoid.svg)

[Demo](https://parseoid.onrender.com/)

The assignment entails developing a feature for dynamically adjusting dates within text lines of templates. This includes parsing and modifying date variables (#d# for day, #m# for month, #y# for year) based on a given reference date, allowing both arithmetic operations and various formats.

## Quickstart

The application is based on [Ruby on Rails](https://rubyonrails.org/) framework. It uses only seweral parts of it without need to run the whole Rails stack including database, redis, and so on. So you can run it locally by following these steps:

### Prerequisites

- Ruby 3.3.0 (not tested with older Ruby 3.x versions)

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
    bin/rails test test:system
    ```

## Deployment

The application is deployed on ]Render](https://render.com). The deployment is done automatically on every push to the master branch if CI workflow passes. The CI workflow is defined in ./.github/workflows/ci.yml. The currently is no option to make a deploy on Render manually from a terminal.

## Useful links

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Hotwire: HTML Over The Wire](https://hotwired.dev/)
- [Brewing our own Template Lexer in Ruby](https://blog.appsignal.com/2019/07/02/ruby-magic-brewing-our-own-template-lexer-in-ruby.html)
- [stimulus-live-elements](https://github.com/superfly/stimulus-live-elements?tab=readme-ov-file)
