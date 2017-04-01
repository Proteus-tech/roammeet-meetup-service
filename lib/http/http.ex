defmodule Meetup.HTTP do
  @moduledoc """
      Websocket Server is created by cowboy.
  """

  def start_link do
    { :ok, _ } = :cowboy.start_http(
      :http,
      100,
      [port: 8009],
      [env: [
          dispatch: routes()
        ]
      ]
    )
  end

  def routes do
    :cowboy_router.compile([
      { :_,
        [
          {"/hello", Meetup.Hello, []},
          {:_, Meetup.HTTP.NotFoundHandler, []},
        ]
      }
    ])
  end
end

defmodule Meetup.HTTP.NotFoundHandler do
    @behaviour :cowboy_http_handler
    @moduledoc """
        This is a stub handler
    """

    def init({ _any, :http }, req, []) do
        { :ok, req, :undefined }
    end

    def handle(req, state) do
        { :ok, req } = :cowboy_req.reply 404, [], "404 Not Found", req
        { :ok, req, state }
    end

    def terminate(_reason, _request, _state) do
        :ok
    end
end
