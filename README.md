<style>
  table * {
    border-left: solid black 1px;
    border-bottom: solid black 1px;
    padding: 10px;
  }
  th {
    background-color: grey;
    color: white;
  }
</style>
# MAC Lockbox

The MAC lockbox is a system for tracking MAC cash at partners across the Midwest. For a detailed list of app functionality, see [docs/roadmap.md](https://github.com/MidwestAccessCoalition/lockbox_rails/blob/master/docs/roadmap.md)

## Local Dev Evnironment
### Requirements
Technical requirements for this project. See below for step-by-step first-time setup.

| Tool | Version |
|------|---------|
| Ruby | v2.6.2 |
| Bundler | v2.0.1 |
| Rails | v6.0.0.beta3 |
| PostgreSQL | v11.2 |
| Node | v11.14.0 |

### Environment Setup
First off, you'll want to clone this repo:
```sh
git clone git@github.com:MidwestAccessCoalition/lockbox_rails
# Or if you don't have an SSH key setup with Github:
# git clone https://github.com/MidwestAccessCoalition/lockbox_rails.git
```

This setup assumes you are using [Homebrew](https://brew.sh/) on a Mac. For other environments, reach out to [@bintLopez](https://github.com/BintLopez) (Nicole).

#### Ruby
If you don't have a Ruby version manager, you'll want to install `rbenv`. If you already have `rbenv` or `rvm` installed, skip this step. **DO NOT INSTALL BOTH RVM AND RBENV ON THE SAME MACHINE**.

To find out if they're already installed, in a terminal run `which rbenv rvm`. If they're both "not found" or there's no output at all, install `rbenv`.
```sh
brew install rbenv # https://github.com/rbenv/rbenv for more info
```
_If you don't have Homebrew installed, or are using a PC or Linux machine, talk to Nicole (@bintLopez) about getting your dev env setup._

To get the correct Ruby version, you can run the following from the project root to get the ruby version specified in the `.ruby-version` file.
```sh
ruby_version=$(cat .ruby-version)
ruby_version=${ruby_version#ruby-} # Remove "ruby-" if prefixed to version number
# Install Ruby via rbenv
rbenv install $ruby_version
# OR if you're using RVM
# rvm install $ruby_version
```

#### Rails
```sh
gem install bundler -v 2.0.1
bundle install # Make sure you're in the lockbox-rails root directory
```

#### PostgreSQL & DB setup
See if you have PostgreSQL:
```sh
which psql
```

If not, install and run it using Homebrew:
```sh
brew install postgresql
brew services start postgresql
```

Setup DB:
```sh
# From project root:
rake db:setup # runs `rake db:create db:schema:load db:seed
```

_If you have issues at this step, see this [PostrgreSQL Setup](https://github.com/MidwestAccessCoalition/jane_point_oh/blob/master/docs/db_setup.md) doc. But while going through it, wherever you see the string `admin_app`, replace it with `lockbox_rails`. (This includes instances like `admin_app_development` => `lockbox_rails_development`.)_

#### Mailcatcher
```sh
gem install mailcatcher
mailcatcher # This will run on localhost:1080
```

#### Node/NPM/Yarn
```sh
brew install nvm
nvm install 11.14.0
nvm use 11.14.0
```

### Login
Username: `cats@test.com`<br>
Password: `password1234`
