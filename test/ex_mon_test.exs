defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},
        name: "Leo"
      }

      assert ExMon.create_player("Leo", :kick, :punch, :heal) == expected_response
    end
  end

  describe "start_game/1" do
    test "when the game is started, returns a message" do
      player = Player.build("Leo", :kick, :punch, :heal)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, execute the move action and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      assert messages =~ ~r/The Player attacked the computer/
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :in_progress"
    end

    test "when the move is valid and current game status is game over, returns the end game message" do
      new_computer_state = %{Game.fetch_player(:computer) | life: 0}
      messages =
        capture_io(fn ->
          Game.update(%{Game.info() | computer: new_computer_state})
          ExMon.make_move(:kick)
        end)

      assert messages =~ "The game is over!"
      assert messages =~ "status: :game_over"
    end

    test "when the move is invalid, returns an error message makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:invalid_move)
        end)

      assert messages =~ "Invalid move: invalid_move."
    end
  end
end
