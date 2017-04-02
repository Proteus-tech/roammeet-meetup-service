defmodule Meetup.Repo.Migrations.AddInvitationTable do
  use Ecto.Migration

  def change do
    create table(:invitation) do
      add :people_id, :integer
      add :meetup_id, references(:meetup)
      add :status, :boolean

      timestamps()
    end
    create unique_index(:invitation, [:people_id, :meetup_id], [])
  end
end
