defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Crazy Rooster"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @computer_name
      |> create_player(:punch, :kick, :heal)
      |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  def make_move(move) do
    move
    |> Actions.fetch_move()
    |> execute_move_action()

    computer_move(Game.info())
  end

  defp execute_move_action({:error, move}), do: Status.print_wrong_move_message(move)

  defp execute_move_action({:ok, move}) do
    case move do
      :move_heal -> Actions.heal()
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  defp computer_move(%{turn: :computer, status: :in_progress}) do
    move = {:ok, Enum.random(@computer_moves)}

    execute_move_action(move)
  end

  defp computer_move(_), do: :ok
end
