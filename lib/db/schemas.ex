defmodule MeetupSchema do
  use Ecto.Schema

  # meetup is the DB table
  schema "meetup" do
    field :name, :string
  end
end
