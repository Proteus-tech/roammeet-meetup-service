defmodule Meetup.MeetupSchema do
  use Ecto.Schema

  # meetup is the DB table
  schema "meetup" do
    field :name, :string
    field :description, :string
    field :start_date, :"date"
    field :start_time, :string

    timestamps()
  end
end

defmodule Meetup.InvitationSchema do
  use Ecto.Schema

  # meetup is the DB table
  schema "invitation" do
    field :people, :string
    field :meetup, :integer
    field :status, :boolean

    timestamps()
  end
end
