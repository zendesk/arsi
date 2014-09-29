# ARSI - ActiveRecord SQL Inspector

ARSI is a library to ensure that potentially dangerous sql statements are always scoped to an id column.

Currently ARSI will intercept ActiveRelation.update_all and ActiveRelation.delete_all method calls and verify that the SQL includes a scoping operator on an id column.

ID Columns:

- *_id
- id
- guid
- uuid
- uid

Operators:

- =
- <>
- IN
- IS

When a violation is found ARSI will trigger the `Arsi.violation_callback` callback and pass the current SQL and ActiveRelation object. The default callback will raise an `Arsi::UnscopedSQL` exception. You can override this callback in an initializer.

## Disabling ARSI

You can disable ARSI for a relation by using `ActiveRelation.without_arsi`

```ruby
User.where(active: false).without_arsi.delete_all # I know what I'm doing...

```


You can also disable ARSI via `ARSI.disable`

```ruby
class ApplicationController < ActionController::Base
  around_filter :configure_arsi
  def configure_arsi
    if use_arsi?
    	yield
    else
    	Arsi.disable { yield }
    end
  end
end
```


## Limitations

1. ARSI only supports MySQL
2. ARSI only supports Rails 3.2
2. ARSI is using regexs and is not parsing the SQL therefore false negatives are possible with specially crafted SQL statements.