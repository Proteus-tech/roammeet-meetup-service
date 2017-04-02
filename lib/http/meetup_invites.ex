defmodule Meetup.HTTP.MeetupInvites do
  @behaviour :cowboy_http_handler
  import Ecto.Query

  alias Meetup.Repo, as: Repo
  alias Meetup.MeetupSchema, as: MeetupSchema
  alias Meetup.InvitationSchema, as: InvitationSchema

  def init({ _any, :http }, req, []) do
    { :ok, req, :undefined }
  end

  def handle(req, state) do
    { method, _ } = :cowboy_req.method req
    IO.puts method
    # IO.inspect map_data
    case method do
      "PUT" ->
        put_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def put_handle(req, state) do
    # IO.inspect Ecto.Date.cast!("2015-05-12")
    # meetup = %MeetupSchema{name: "Ben", description: "555", start_date: Ecto.Date.cast!("2015-05-12"), start_time: "500"}
    # Repo.insert!(meetup)
    { id, _ } = :cowboy_req.binding(:id, req)
    { :ok, body, req } = :cowboy_req.body_qs(req)
    if body !== [] do
      body = body |> List.first |> elem 0
      body = Poison.decode!(body, keys: :atoms)
      require_field = [:people]
      mf = miss_fieldes(require_field, Map.keys(body))
      if mf == [] do
        IO.inspect body
        invitation = %InvitationSchema{
          people_id: Map.get(body, :people),
          meetup_id: id,
          status: false
        }
        Repo.insert!(invitation)
        status_code = 200
        data = Poison.encode!(body)
      else
        status_code = 400
        data = Poison.encode!(mf)
      end
    else
      status_code = 400
      data = "No body."
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
