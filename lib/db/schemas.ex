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
