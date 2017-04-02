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
          {"/meetups", Meetup.HTTP.Meetups, []},
          {"/meetup/:id", Meetup.HTTP.Meetup, []},
          {"/meetup/:id/invitations/status/:status", Meetup.HTTP.Meetup, []}, # Get All invite status from a meetup
          {"/meetup/:id/invitations", Meetup.HTTP.MeetupInvites, []}, # Send an invitation
          {"/invitations/people/:id", Meetup.HTTP.Invitations, []},
          {:_, Meetup.HTTP.NotFoundHandler, []},
        ]
      }
    ])
  end
end
