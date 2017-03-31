defmodule Meetup do
  @moduledoc """
  Documentation for Meetup.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Meetup.hello
      :world

  """
  def start(_type, _args) do
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
      ]}
    ])
  end
end
