defmodule Meetup.Schema.Meetup do
  use Ecto.Schema

  # meetup is the DB table
  @derive {Poison.Encoder, only: [:id, :name, :description, :start_date, :start_time, :invitations]}
  schema "meetup" do
    field :name, :string
    field :description, :string
    field :start_date, :"date"
    field :start_time, :string
    has_many :invitations, Meetup.Schema.Invitation
    timestamps()
  end
end

defmodule Meetup.Schema.Invitation do
  use Ecto.Schema

  # invitation is the DB table
  @derive {Poison.Encoder, only: [:id, :people_id, :meetup_id, :status, :meetups]}
  schema "invitation" do
    field :people_id, :integer
    field :meetup_id, :integer
    field :status, :boolean
    belongs_to :meetups, Meetup.Schema.Meetup
    timestamps()
  end
end
