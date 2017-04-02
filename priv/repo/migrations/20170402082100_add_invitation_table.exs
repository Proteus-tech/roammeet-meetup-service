defmodule Meetup.Repo.Migrations.AddInvitationTable do
  use Ecto.Migration

  def change do
    create table(:invitation) do
      add :people, :string
      add :meetup, references(:meetup)
      add :status, :boolean

      timestamps()
    end
    create unique_index(:invitation, [:people, :meetup], [])
  end
end
