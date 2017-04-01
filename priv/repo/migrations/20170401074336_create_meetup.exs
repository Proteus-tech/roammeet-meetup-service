defmodule Meetup.Repo.Migrations.CreateMeetup do
  use Ecto.Migration

  def change do
    create table(:meetup) do
      add :name,    :string

      timestamps()
    end
  end
end
