# ARSI - ActiveRecord SQL Inspector [![CI](https://github.com/zendesk/arsi/actions/workflows/actions.yml/badge.svg)](https://github.com/zendesk/arsi/actions/workflows/actions.yml)

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

 - MySQL
 - uses regexs on SQL, false negatives with specially crafted SQL statements can occur

### Releasing a new version
A new version is published to RubyGems.org every time a change to `version.rb` is pushed to the `main` branch.
In short, follow these steps:
1. Update `version.rb`,
2. update version in all `Gemfile.lock` files,
3. merge this change into `main`, and
4. look at [the action](https://github.com/zendesk/arsi/actions/workflows/publish.yml) for output.

To create a pre-release from a non-main branch:
1. change the version in `version.rb` to something like `1.2.0.pre.1` or `2.0.0.beta.2`,
2. push this change to your branch,
3. go to [Actions → “Publish to RubyGems.org” on GitHub](https://github.com/zendesk/arsi/actions/workflows/publish.yml),
4. click the “Run workflow” button,
5. pick your branch from a dropdown.
