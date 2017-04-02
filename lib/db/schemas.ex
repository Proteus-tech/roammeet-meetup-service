defmodule Meetup.Schema.Meetup do
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

defmodule Meetup.Schema.Invitation do
  use Ecto.Schema

  # invitation is the DB table
  schema "invitation" do
    field :people_id, :integer
    field :meetup_id, :integer
    field :status, :boolean
    timestamps()
  end
end

defmodule Meetup.Meetup do
  use Ecto.Schema

  # meetup is the DB table
  @derive {Poison.Encoder, only: [:id, :name, :description, :start_date, :start_time, :invitation]}
  schema "meetup" do
    field :name, :string
    field :description, :string
    field :start_date, :"date"
    field :start_time, :string
    has_many :invitation, Meetup.Invitation
    timestamps()
  end
end

defmodule Meetup.Invitation do
  use Ecto.Schema

  # invitation is the DB table
  @derive {Poison.Encoder, only: [:id, :people_id, :status, :meetup]}
  schema "invitation" do
    field :people_id, :integer
    field :status, :boolean
    belongs_to :meetup, Meetup.Meetup
    timestamps()
  end
end
