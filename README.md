# Notes API

[![CI](https://github.com/MauricioCen/notes-api/actions/workflows/ci.yml/badge.svg)](https://github.com/MauricioCen/notes-api/actions/workflows/ci.yml) [![Linter](https://github.com/MauricioCen/notes-api/actions/workflows/linter.yml/badge.svg)](https://github.com/MauricioCen/notes-api/actions/workflows/linter.yml)

Notes REST API.

## Requirements

- Ruby 2.7+.
- SQLite 3+.

## Installation

```sh
bundle install
```

## Development

Run migrations:

```sh
bundle exec rake db:migrate RACK_ENV=development
```

Start the web server:

```sh
rackup -p 9292
```

### Tests

Run migrations:

```sh
bundle exec rake db:migrate RACK_ENV=test
```

Run tests:
```sh
bundle exec rake test
```

### Rake tasks

Show tasks:

```sh
bundle exec rake -T
```

Run linter:

```sh
bundle exec rake rubocop
```

### Command line

Start command line:

```sh
ruby bin/console
```