# WFP mVAM food security survey chatbot

Spike for a Telegram chatbot for running food security surveys for WFP mVAM. Powered by Pandorabots. Uses the [Ruby Telegram Bot boilerplate](https://github.com/MaximAbramchuck/ruby-telegram-bot-starter-kit).

## Running the bot

First you need to install gems required to start a bot:

```sh
bundle install
```

Then you need to create `secrets.yml` where your bot unique token will be stored and `database.yml` where database credentials will be stored. I've already created samples for you, so you can easily do:

```sh
cp config/database.yml.sample config/database.yml
cp config/secrets.yml.sample config/secrets.yml
```

Then you need to fill your [Telegram bot unique token](https://core.telegram.org/bots#botfather) to the `secrets.yml` file and your database credentials to `database.yml`.

After this you need to create and migrate your database:

```sh
rake db:create db:migrate
```

Great! Now you can easily start your bot just by running this command:

```sh
bin/bot
```
