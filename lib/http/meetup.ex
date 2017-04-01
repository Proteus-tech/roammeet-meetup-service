defmodule Meetup.Meetup do
  @behaviour :cowboy_http_handler
  import Ecto.Query

  alias Meetup.Repo, as: Repo
  alias Meetup.MeetupSchema, as: MeetupSchema

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
      body = body |> List.first |> elem 0
      body = Poison.decode!(body, keys: :atoms)
      require_field = [:name, :description, :start_date, :start_time]
      mf = miss_fieldes(require_field, Map.keys(body))
      if mf == [] do
        IO.inspect body
        meetup = %MeetupSchema{
          name: Map.get(body, :name),
          description: Map.get(body, :description),
          start_date: Ecto.Date.cast!(Map.get(body, :start_date)),
          start_time: Map.get(body, :start_time)
        }
        Repo.insert!(meetup)
        { :ok, req } = :cowboy_req.reply 200, [], Poison.encode!(body), req
        { :ok, req, state }
      else
        { :ok, req } = :cowboy_req.reply 400, [], Poison.encode!(mf), req
        { :ok, req, state }
      end
    else
      { :ok, req } = :cowboy_req.reply 400, [], "-*-", req
      { :ok, req, state }
    end
  end

  def miss_fieldes(require_field, keys_body) do
    Enum.filter(require_field, fn(f) -> not Enum.member?(keys_body, f) end)
  end

  def terminate( reason, request, state) do
    :ok
  end
end
