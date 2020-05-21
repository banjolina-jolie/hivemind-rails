# hivemind-rails

- start local postgres (I use [this](https://www.postgresql.org/download/))
- start local redis (`redis-server /usr/local/etc/redis.conf`)
- prepare local db
```
rails db:drop db:create db:migrate db:seed
```
- start rails server
```
rails s
```
- start sidekiq
```
bundle exec sidekiq
```
