# Sir Alex ![Sir Alex Build Status](https://img.shields.io/circleci/project/github/dnsbty/sir_alex/master.svg)
![ferguson-celebrate](https://user-images.githubusercontent.com/3421625/32137456-8b8a2236-bbdd-11e7-82a2-b6e28f4b2fd7.gif)

Sir Alex is a group management platform, built on top of [Elixir](https://github.com/elixir-lang/elixir) and [Phoenix](https://github.com/phoenix-framework/phoenix). For more information on what this is going to be, check out [my essay on Sir Alex](https://dennisbeatty.com/2017/10/20/sir-alex-open-source-group-management-platform.html).

## Running the server

1. Make sure you have [Elixir 1.5 and OTP 20 installed](https://elixir-lang.org/install.html)
2. Make sure you have Postgres installed and running.
2. Clone the repo onto your local machine: `git clone git@github.com:dnsbty/sir_alex.git`
3. Install the project's dependencies: `cd sir_alex && mix deps.get`
4. Create and migrate the database: `mix ecto.create && mix ecto.migrate`
5. Install node.js dependencies: `cd assets && npm install`
6. Start the server: `mix phx.server`

Now you can visit [http://localhost:4000](http://localhost:4000) in your browser.
