defmodule Meetup.Hello do
  @behaviour :cowboy_http_handler

  def init({ _any, :http }, req, []) do
    { :ok, req, :undefined }
  end

  def handle(req, state) do
    { :ok, req } = :cowboy_req.reply 200, [], 'TEST', req
    { :ok, req, state }
  end

  def terminate( reason, request, state) do
    :ok
  end
end
