defmodule ExMon.Game.StatusTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Game.Status
  alias ExMon.Player

  describe "print_round_message/1" do
    test "when the game info has status started, returns the game is started message" do
      game_info =  %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Crazy Rooster"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Leo"
        },
        status: :started,
        turn: :player
      }

      messages =
        capture_io(fn ->
          Status.print_round_message(game_info)
        end)

      assert messages =~ "The game is started"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end

    test "when the game info has status in_progress, returns the message saying that's the turn for the given player" do
      game_info =  %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Crazy Rooster"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Leo"
        },
        status: :in_progress,
        turn: :player
      }

      messages =
        capture_io(fn ->
          Status.print_round_message(game_info)
        end)

      assert messages =~ "It's player turn."
      assert messages =~ "status: :in_progress"
      assert messages =~ "turn: :player"
    end

    test "when the game info has status game_over, returns the game is over message" do
      game_info =  %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Crazy Rooster"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Leo"
        },
        status: :game_over,
        turn: :player
      }

      messages =
        capture_io(fn ->
          Status.print_round_message(game_info)
        end)

      assert messages =~ "The game is over!"
      assert messages =~ "status: :game_over"
    end
  end

  describe "print_wrong_move_message/1" do
    test "returns invalid move message for the given move" do
      messages =
        capture_io(fn ->
          Status.print_wrong_move_message(:invalid_move)
        end)

      assert messages =~ "Invalid move: invalid_move."
    end
  end
end
