defmodule Meetup do
  @moduledoc """
  Documentation for Meetup.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Meetup.Repo, [], restart: :transient),
      worker(Meetup.HTTP, [], restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: Meetup.Supervisor]
    Supervisor.start_link(children, opts)
   end
end
