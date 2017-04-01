defmodule Meetup.Repo.Migrations.CreateMeetup do
  use Ecto.Migration

  def change do
    create table(:meetup) do
      add :name, :string
      add :description, :string
      add :start_date, :"date"
      add :start_time, :string

      timestamps()
    end
  end
end
