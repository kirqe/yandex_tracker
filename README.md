# YandexTracker

TODO: Delete this and the text below, and describe your gem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/yandex_tracker`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

#### Configure, client

```ruby
  # with client_id, client_secret and code from callback
  YandexTracker.configure do |config|
    config.client_id = "abc"
    config.client_secret = "def"
    config.org_id = "123" # or cloud_org_id
  end

  YandexTracker::Auth.exchange_code(code)

  # if already have access_token and don't plan to refresh it
  YandexTracker.configure do |config|
    config.access_token = "xyz"
    config.org_id = "123" # or cloud_org_id
  end

  client = YandexTracker::Client.new
```

#### Users

```ruby
  client.users.list
  client.users.find("xyz")
  client.users.myself
```

#### Queues

```ruby
  client.queues.list
  client.queues.find("MYQUEUE")
  client.queues.create(
    key: "MYQUEUE",
    name: "MYQUEUE",
    lead: "me",
    defaultType: "task",
    defaultPriority: "normal",
    issueTypesConfig: {
      issueType: "task",
      workflow: "developmentPresetWorkflow",
      resolutions: ["wontFix"]
    }
  )
```

#### Issues

```ruby
  client.issues.list
  client.find.find("TEST-1")
  client.issues.create(
    queue: "MYQUEUE",
    summary: "abc"
  )
```

#### Comments

```ruby
  client.comments.list
  client.comments.create("TEST-1", text: "zxc")
```

#### Attachments

```ruby
  client.attachments.list
  client.attachments.create("TEST-1", "issue-1.png", filename: "issue-1")
  client.attachments.create_temp("issue-1.png", filename: "issue-1")
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yandex_tracker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
