defmodule Meetup.Meetup do
  @behaviour :cowboy_http_handler

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
      "POST" ->
        post_handle(req, state)
      _ ->
        { :ok, req } = :cowboy_req.reply 400, [], '-*-', req
        { :ok, req, state }
    end
  end

  def get_handle(req, state) do
    { :ok, req } = :cowboy_req.reply 200, [], 'GET TEST', req
    { :ok, req, state }
  end

  def post_handle(req, state) do
    { :ok, req } = :cowboy_req.reply 200, [], 'POST TEST', req
    { :ok, req, state }
  end

  def terminate( reason, request, state) do
    :ok
  end
end
