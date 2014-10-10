# ARSI - ActiveRecord SQL Inspector

[![Build Status](https://magnum.travis-ci.com/zendesk/arsi.svg?token=MsU5XFxeU3atFLQoVGDv&branch=master)](https://magnum.travis-ci.com/zendesk/arsi)

Block sql statements that are not scoped by id in `.update_all` and `.delete_all`.

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

Triggers the `Arsi.violation_callback` with SQL and relation object.By default raise `Arsi::UnscopedSQL`.

## Disabling

via `.without_arsi`

```ruby
User.where(active: false).without_arsi.delete_all # I know what I'm doing...

```

via `ARSI.disable`

```ruby
class ApplicationController < ActionController::Base
  around_filter :without_arsi
  def without_arsi(&block)
    Arsi.disable(&block)
  end
end

Arsi.disable do
  User.update_all name: "Pete" # will be ignored
end
```


## Limitations

 - MySQL on Rails 3.2
 - uses regexs on SQL, false negatives with specially crafted SQL statements can occur
