defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)
      expected_response = %{
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
      Game.start(computer, player)

      assert Game.info() == expected_response
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)
      expected_current_state = %{
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
      new_state = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Crazy Rooster"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Leo"
        },
        status: :started,
        turn: :player
      }

      Game.start(computer, player)
      assert Game.info() == expected_current_state
      Game.update(new_state)
      assert Game.info() == %{new_state | turn: :computer, status: :in_progress}
    end
  end

  describe "player/0" do
    test "returns the player info" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "Leo"
      }
      Game.start(computer, player)

      assert Game.player() == expected_response
    end
  end

  describe "turn/0" do
    test "returns whose current turn is" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)
      Game.start(computer, player)

      assert Game.turn() == :player
    end
  end

  describe "fetch_player/1" do
    test "returns the current info for the given player" do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "Crazy Rooster"
      }
      Game.start(computer, player)

      assert Game.fetch_player(:computer) == expected_response
    end
  end
end
