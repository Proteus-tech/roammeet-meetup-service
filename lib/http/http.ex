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
          {"/meetup", Meetup.Meetup, []},
          {"/meetup-detail/:id", Meetup.MeetupDetail, []},
          {:_, Meetup.HTTP.NotFoundHandler, []},
        ]
      }
    ])
  end
end
