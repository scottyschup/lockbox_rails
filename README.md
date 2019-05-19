# MAC Lockbox

The MAC lockbox is a system for tracking MAC cash at partners across the Midwest. For a detailed list of app functionality, see [docs/roadmap.md](https://github.com/MidwestAccessCoalition/lockbox_rails/blob/master/docs/roadmap.md)

# Local dev setup

## Requirements

- Ruby v2.6.2
- Rails v6.0.0.beta3
- Node v11.14.0
- PostgreSQL 11.2

# Setting up your database

rake db:create
rake db:migrate

#### Set up local email interceptor

```sh
gem install mailcatcher
mailcatcher
```
