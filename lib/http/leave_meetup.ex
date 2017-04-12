defmodule Meetup.HTTP.LeaveMeetup do
  @behaviour :cowboy_http_handler
  import Ecto.Query, only: [from: 2]

  alias Meetup.Repo, as: Repo
  alias Meetup.Schema.Meetup, as: MeetupSchema
  alias Meetup.Schema.Invitation, as: InvitationSchema

  def init({ _any, :http }, req, []) do
    { :ok, req, :undefined }
  end

  def handle(req, state) do
    { method, _ } = :cowboy_req.method req
    IO.puts method
    # IO.inspect map_data
    case method do
      "DELETE" ->
        delete_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def delete_handle(req, state) do
    { id, _ } = :cowboy_req.binding(:id, req)
        |> elem(0)
        |> Integer.parse
    { :ok, body, req } = :cowboy_req.body_qs(req)
    if body !== [] do
      payload = body
        |> List.first
        |> elem(0)
        |> Poison.decode!(keys: :atoms)
      require_field = [:people]
      mf = miss_fieldes(require_field, Map.keys(payload))
      if mf == [] do
        people_id = Map.get(payload, :people)
        # IO.puts people_id
        invitation = (from i in InvitationSchema, where: i.people_id == ^people_id)
          |> Repo.delete_all

          status_code = 200
          data = Poison.encode!(payload)
      else
        status_code = 400
        data = Poison.encode!(mf)
      end
    else
      status_code = 400
      data = "Invalid payload data."
    end
    { :ok, req } = :cowboy_req.reply status_code, [], data, req
    { :ok, req, state }
  end

  def miss_fieldes(require_field, keys_body) do
    Enum.filter(require_field, fn(f) -> not Enum.member?(keys_body, f) end)
  end

  def terminate(_reason, _request, _state) do
    :ok
  end
end
