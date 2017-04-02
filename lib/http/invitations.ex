defmodule Meetup.HTTP.Invitations do
  @behaviour :cowboy_http_handler
  import Ecto.Query, only: [from: 2]

  alias Meetup.Repo, as: Repo
  alias Meetup.Meetup, as: MeetupMeetup

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
      # "PUT" ->
      #   put_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def get_handle(req, state) do
    meetup = Repo.all(from u in MeetupMeetup, preload: [:invitation])
    # meetup = MeetupSchema2
    #   |> select([m], m)
    #   |> Repo.all
    # meetup = meetup |> Repo.preload(:invitation)
    IO.inspect meetup
    { :ok, req } = :cowboy_req.reply 200, [], "555", req
    { :ok, req, state }
  end

  # def put_handle(req, state) do
  #   # IO.inspect Ecto.Date.cast!("2015-05-12")
  #   # meetup = %MeetupSchema{name: "Ben", description: "555", start_date: Ecto.Date.cast!("2015-05-12"), start_time: "500"}
  #   # Repo.insert!(meetup)
  #   { :ok, body, req } = :cowboy_req.body_qs(req)
  #   if body !== [] do
  #     body = body |> List.first |> elem 0
  #     body = Poison.decode!(body, keys: :atoms)
  #     require_field = [:name, :description, :start_date, :start_time]
  #     mf = miss_fieldes(require_field, Map.keys(body))
  #     if mf == [] do
  #       IO.inspect body
  #       meetup = %MeetupSchema{
  #         name: Map.get(body, :name),
  #         description: Map.get(body, :description),
  #         start_date: Ecto.Date.cast!(Map.get(body, :start_date)),
  #         start_time: Map.get(body, :start_time)
  #       }
  #       Repo.insert!(meetup)
  #       status_code = 200
  #       data = Poison.encode!(body)
  #     else
  #       status_code = 400
  #       data = Poison.encode!(mf)
  #     end
  #   else
  #     status_code = 400
  #     data = "No body."
  #   end
  #   { :ok, req } = :cowboy_req.reply status_code, [], data, req
  #   { :ok, req, state }
  # end

  def miss_fieldes(require_field, keys_body) do
    Enum.filter(require_field, fn(f) -> not Enum.member?(keys_body, f) end)
  end

  def terminate(_reason, _request, _state) do
    :ok
  end
end
