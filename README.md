# hivemind-rails

- start local postgres (I use [this](https://www.postgresql.org/download/))
- start local redis (`redis-server /usr/local/etc/redis.conf`)

```
rails db:drop db:create db:migrate db:seed
rails s
bundle exec sidekiq
```
