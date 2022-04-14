defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Crazy Rooster"
  @computer_moves [:move_avg, :move_rnd, :move_heal]
  @weighted_computer_moves [{1, :move_avg}, {1, :move_rnd}, {10, :move_heal}]

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    initial_turn = Enum.random([:computer, :player])

    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player, initial_turn)

    Status.print_round_message(Game.info())

    case initial_turn do
      :computer -> computer_move(%{Game.info() | status: :in_progress})
      _ -> :ok
    end
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_game_status(move)
  end

  defp handle_game_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_game_status(_other, move) do
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

  defp computer_move(%{turn: :computer, status: :in_progress, computer: computer})
       when computer.life < 40 do
    move =
      @weighted_computer_moves
      |> Enum.map(fn {weight, move} -> List.duplicate(move, weight) end)
      |> List.flatten()
      |> Enum.random()

    execute_move_action({:ok, move})
  end

  defp computer_move(%{turn: :computer, status: :in_progress, computer: computer})
       when computer.life > 40 do
    move = Enum.random(@computer_moves)

    execute_move_action({:ok, move})
  end

  defp computer_move(_), do: :ok
end
