# Rails51

This gem adds some handy capistrano tasks (for now)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails51'
```

## Capistrano Tasks

### pg:import

This task imports in local postgres database a remote dump. Just call

```bash
cap production pg:import
```

This will:

1. Dump the database on the server with `--clean and --no-owner` flags, and gzips it. Fetch database name and eventually port from `:release_path/config/database.yml` file
2. Download the file and uncompress
3. Import in the database defined in local `database.yml` file

**Known Issues:**

* Does not work with password authentication (for now)

### logs:tail

This task simply stream the `tail -f` results of `log/#{fetch(:rails_env, 'production')}.log` file locally.

**Known Issues:** If you use Airbrussh, you won't see anything because all the stdout is sent to `log/capistrano.log`. You can either use [my fork](https://github.com/carlesso/airbrussh) or wait for [this pr](https://github.com/mattbrictson/airbrussh/pull/4) to be merged.

### rails:console

Inspired (and mostly copied) from [capistrano-rails-console](https://github.com/ydkn/capistrano-rails-console) this task allows you to launch a `rails console` in the target environment without the need of ssh, find the right directory, RAILS\_ENV etc etc...

Just type

```bash
cap production rails:console
```

and you will have your console.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails51/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
