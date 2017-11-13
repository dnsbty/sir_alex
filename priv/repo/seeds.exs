# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SirAlex.Repo.insert!(%SirAlex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SirAlex.Repo
alias SirAlex.Accounts.User
alias SirAlex.Groups.{
  Group,
  Member
}

user = Repo.insert!(%User{
  email: "dennis@dcbeatty.com",
  facebook_id: "10155960225108083",
  name: "Dennis Beatty"
})

public_group = Repo.insert!(%Group{
  name: "A Public Group",
  description: "This will be a super awesome public group.",
  is_private: false
})

private_group = Repo.insert!(%Group{
  name: "A Private Group",
  description: "This will be a super awesome private group.",
  is_private: true
})

Repo.insert!(%Member{
  user_id: user.id,
  group_id: public_group.id,
  role: "admin"
})

Repo.insert!(%Member{
  user_id: user.id,
  group_id: private_group.id,
  role: "admin"
})
