defmodule Meetup.HTTP.Meetup do
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
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def get_handle(req, state) do
    { id, _ } = :cowboy_req.binding(:id, req)
    meetup = MeetupSchema
      |> select([m], %{
        "id" => m.id,
        "name" => m.name,
        "description" => m.description,
        "start_date" => m.start_date(),
        "start_time" => m.start_time
        })
      |> where([m], m.id == ^id)
      |> Repo.one
    { :ok, req } = :cowboy_req.reply 200, [], Poison.encode!(meetup), req
    { :ok, req, state }
  end

  def terminate(_reason, _request, _state) do
    :ok
  end
end
