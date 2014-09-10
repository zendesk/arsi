# ARSI - ActiveRecord SQL Inspector

ARSI is a library that allows you to specify requirements about the SQL statements you pass to the database.

## Configuration

You can configure ARSI global settings in an initializer:

```ruby
Arsi.configure :enabled => (true|false), :mode => (:raise|:log)
```

Outside that, you can also set values for global directives:

```ruby
# any query that matches a whitelist will be exempt from all requirements
Arsi.whitelist { |sql| sql =~ /FROM translations/ }
Arsi.reject    { |sql| sql !~ /account_id = \d+/) }
Arsi.require(:account_id)   { |sql| sql =~ /account_id = \d+/) }
```

To configure ARSI per request use an around_filter:

```ruby
class ApplicationController < ActionController::Base
  around_filter :configure_arsi
  def configure_arsi
    Arsi.configure(:enabled => :true, :mode => :raise) do
      yield
    end
  end
end
```

You can also provide a string or an regular expression to Arsi directives.

```ruby
ARSI.reject(:prevent_schmea_mods, "DROP TABLE")
ARSI.reject(Regexp.new("/SELECT\.+(DROP)/i"))
ARSI.reject { |sql| sql.size > 10000 }
```

You can override the global directives on a scope level by calling the AREL level `arsi` method:

```ruby
User.arsi(:ignore => :account_id).count
User.arsi(:ignore => Regexp.new(...)).find_by_sql(sql)
User.arsi(:reject => [ ], :ignore => ...)
User.arsi(:reject => "foo").arsi(:reject => /bar/)
User.arsi(:reject => ->(sql){ sql =~ 'drop table' })
User.arsi(:mode => :log)

User.verified.recently_signed_up.where("blah blah").arsi(:ignore, :account_id)
User.verified.recently_signed_up.where("blah blah").arsi(:require => {:named_require => "account_id"})

User.verified.recently_signed_up.where("blah blah").arsi(:require) {|sql| sql =~ /.../}
User.verified.recently_signed_up.where("blah blah").arsi(:reject, :account_id)
User.verified.recently_signed_up.where("blah blah").arsi(:ignore, :account_id)

```


```ruby
User.scope :arsi_prevent_schema_mods -> (arsi_require("DROP TABLE"))

User.arsi_require(:prevent_schema_mods, "DROP TABLE")
User.arsi_require(:prevent_schema_mods) ->(sql) { %w(DROP ALTER CREATE).detect {|cmd| sql.include?(cmd)}.any?}
User.arsi_require(:account_id, /account_id = \d+/)

User.verified.arsi_ignore(:prevent_schema_mods)

```

## TODO

:ignore vs. :whitelist vs. arsi(false) etc. - refine the API syntaxes

## Issues

1. Will simple string matching and regexs work or do we need to parse SQL and/or inspect the AREL AST?
2. We need to allow naming of arsi requirments so we can opt-out of them later
3. Are ARSI scopes global or tied to a specific model? I think global makes more sense
4. Should we even support adding restrictions tied to a relation chain? Not sure what the point would be.


