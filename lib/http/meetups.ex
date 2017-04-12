defmodule Meetup.HTTP.Meetups do
  @behaviour :cowboy_http_handler
  import Ecto.Query

  alias Meetup.Repo, as: Repo
  alias Meetup.Schema.Meetup, as: MeetupSchema

  def init({ _any, :http }, req, []) do
    { :ok, req, :undefined }
  end

  def handle(req, state) do
    { method, _ } = :cowboy_req.method req
    IO.puts method
    # IO.inspect map_data
    case method do
      "GET" ->
        get_handle(req, state)
      "PUT" ->
        put_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def get_handle(req, state) do
    meetup = MeetupSchema
      |> select([m], %{
        "id" => m.id,
        "name" => m.name,
        "description" => m.description,
        "start_date" => m.start_date(),
        "start_time" => m.start_time
        })
      |> Repo.all
    { :ok, req } = :cowboy_req.reply 200, [], Poison.encode!(meetup), req
    { :ok, req, state }
  end

  def put_handle(req, state) do
    # IO.inspect Ecto.Date.cast!("2015-05-12")
    # meetup = %MeetupSchema{name: "Ben", description: "555", start_date: Ecto.Date.cast!("2015-05-12"), start_time: "500"}
    # Repo.insert!(meetup)
    { :ok, body, req } = :cowboy_req.body_qs(req)
    if body !== [] do
      payload = body
        |> List.first
        |> elem(0)
        |> Poison.decode!(keys: :atoms)

      require_field = [:name, :description, :start_date, :start_time]
      mf = miss_fieldes(require_field, Map.keys(payload))
      if mf == [] do
        IO.inspect payload
        meetup = %MeetupSchema{
          name: Map.get(payload, :name),
          description: Map.get(payload, :description),
          start_date: Ecto.Date.cast!(Map.get(payload, :start_date)),
          start_time: Map.get(payload, :start_time)
        }
        Repo.insert!(meetup)
        status_code = 200
        data = Poison.encode!(payload)
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
