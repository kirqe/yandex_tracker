# YandexTracker

Ruby API client for [YandexTracker](https://yandex.cloud/en-ru/docs/tracker/about-api) with partially implemented resources for essential needs

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add yandex-tracker

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install yandex-tracker

## Configure

```ruby
  YandexTracker.configure do |config|
    config.client_id = "abc"
    config.client_secret = "def"
    config.org_id = "123" # or cloud_org_id
  end

  YandexTracker::Auth.exchange_code(code)

  # or

  YandexTracker.configure do |config|
    config.access_token = "xyz"
    config.org_id = "123" # or cloud_org_id
  end
```

## Usage

```ruby
  client = YandexTracker::Client.new

  client.users.myself

  client.resolutions.list
  client.workflows.list

  myqueue = client.queues.create(
    key: "MYQUEUE",
    name: "MYQUEUE",
    lead: "me", # should have correct name
    defaultType: "task",
    defaultPriority: "normal",
    issueTypesConfig: {
      issueType: "task",
      workflow: "developmentPresetWorkflow",
      resolutions: ["wontFix"]
    }
  ) #<YandexTracker::Objects::Queue>

  myqueue.issues #<YandexTracker::Collections::Issues>

  issue = myqueue.issues.create(summary: "zxc")
  comment = issue.comments.create(text: "ok")

  issue.attachments.create(File.open("Screenshot.png"))

  unattached_file = client.attachments.create(File.open("Screenshot.png"))
  comment.create(text: "More details", attachmentIds: [temp_attachment.id])

  issue.transitions
  issue.transition('wont_fix', comment: 'wae')
  issue.transition('reopen', comment: 'no')
  issue.transition('close', resolution: 'wontFix')

  client.issues.list
  client.issues(queue: "MYQUEUE").list
  attachments = client.attachments(issue: "MYQUEUE-1").list
  attachments.first.download

  client.comments(issue: "MYQUEUE-1").create(text: "hello")

  issue = client.issues.search({
    filter: { queue: "TEST", status: "open"}},
    expand: "attachments"
  ).first

  issue.createdBy
  issue.createdBy.expand

  issue.attachments
  issue.data

  client.issues.import({
    queue: "TEST",
    summary: "Test",
    createdAt: "2017-08-29T12:34:41.740+0000",
    createdBy: "username",
    ...
  })

  client.fields.create({name: { en: "My Field", ru: "Моe поле" }, id: "myglobalfield"})


  client.categories.list
  client.categories.create(
    name: { en: "My Category", ru: "Моя Категория" },
    order: 1
  )

  myqueue.local_fields.list
  myqueue.local_fields.create(
    name: { en: "My Field", ru: "Моe поле" },
    id: "myglobalfield",
    category: "0000000000000003********",
    type: "ru.yandex.startrek.core.fields.StringFieldType"
  )
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
