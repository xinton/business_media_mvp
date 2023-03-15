# Business Media MVP

## Ruby/Rails version

Rails version             7.0.3.1
Ruby version              ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux-gnu]
RubyGems version          3.1.2
Rack version              2.2.4

Database adapter          sqlite3

## System dependencies

Installed Gems:

- gem 'aasm', '~> 5.3.0'
- gem 'rspec-rails'
- gem 'rails-controller-testing'
- gem 'database_cleaner-active_record'

## Configuration

Clone the project and in directory terminal, run `bin/rails server` to enable the project to receive requests.

Project running on `http://localhost:3000/`

## Database creation

In the project directory, run: `bin/rails db:migrate`

## Database initialization

To create the Organization and User, first access the database console: `bin/rails dbconsole`

- **Create Organization example**

  `insert into organizations (name, slug, created_at, updated_at) values ('Organization Exemple','orgex', datetime('now'), datetime('now'));`
- **Create the User example**
  Get a Organization `id`  created manually
  The roles are: `chief` for Editor Chief, `writer` for Writer and `reviewer` for Reviwer

  `insert into users (name, email, password_digest, role,organization_id, created_at, updated_at) values ('Editor Chief', 'chief@email.com', '123', 'chief', 1, datetime('now'), datetime('now'));`

## How to run the test suite

- **Run all specs in the project on spec folder:** `bundle exec rspec`
- **Run specs under a folder:** `bundle exec rspec spec/example_folder`
- **Run single file test:** `bundle exec rspec spec/exemple_folder/example_spec.rb`
- **Run a test or a subtest of test:** `bundle exec rspec spec/exemple_folder/example_spec.rb:28`
  Where 28 is a row that start a 'it', 'describe' or 'contenxt' block

## What was missing

- Only the "straight line" flow was be made. The "Pending" to "Draft" and "Approved" to "Archivied" was not made, has the button but not the function;
- The Comments feature.
- The project was made using the SQLite, and not MySQL.
- List filters.
- Story flow error messages.
- "Only the Chief Editor, and the Writer and Reviewer assigned to the story can see the
  content of a story before it’s been published, after that though, any other user can
  view its content (by clicking to show the body in the Stories index)."

## What can be improved

- Use a "professional" authorization Gem like `Devise`.
- More worked layout.
- Put the Organization slug on URL.
- By mistake, different types were created for writer and reviewer.
- Complete back-end policy verification.
