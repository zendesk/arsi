# ARSI - ActiveRecord SQL Inspector

ARSI is a library that allows you to put requirements the SQL statements you pass to the database.

## Configuration

You can configure ARSI global settings in e.g. an initializer:

```ruby
ARSI.mode = [ :disabled | :fail | :log ]
ARSI.mode do
  # Something that allows us to disable/log on a per
  # request basis so we can use e.g. Arturo
end
```

Outside that, you can also set values for global directives:

```
ARSI.whitelist { |sql| sql =~ /FROM users/ }
ARSI.reject    { |sql| sql !~ /account_id = \d+/) }
ARSI.require   { |sql| sql =~ /account_id = \d+/) }
```

In the above, each directive is configured with a block. Alternatively, you can provide a string that *must* be included in the generated SQL, or a regular expression that *must* match the generated SQL in order for the directive to resolve to true. For example:

```ruby
ARSI.reject("DROP TABLE")
ARSI.reject(Regexp.new("/SELECT\.+(DROP)/i"))
ARSI.reject({ |sql| sql.size > 10000 })
```

You can override the global directives on a scope level by calling the AREL level `arsi` method:

```ruby
User.arsi(:ignore).count
User.arsi(:ignore => Regexp.new(...)).find_by_sql(sql)
User.arsi(:reject => [ ], :ignore => ...)
User.arsi(:reject => "foo").arsi(:reject => /bar/)
User.arsi(:mode => :log)
```

## TODO

:ignore vs. :whitelist vs. arsi(false) etc. - refine the API syntaxes

