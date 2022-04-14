defmodule ExMon.Game.ActionTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions

  describe "heal/0" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      {:ok, player: player, computer: computer}
    end

    test "when it's the player turn, executes the heal action to recover the own life points",
         %{player: player} do
      # simulating an attack to Player in computer turn
      Game.update(%{Game.info() | player: %{player | life: 20}, turn: :computer})

      capture_io(fn ->
        Actions.heal()
      end)

      assert Game.info().player.life > 20
    end

    test "when it's the computer turn, executes the heal action to recover the own life points",
         %{computer: computer} do
      # simulating an attack to Computer in player turn
      Game.update(%{Game.info() | computer: %{computer | life: 30}, turn: :player})

      capture_io(fn ->
        Actions.heal()
      end)

      assert Game.info().computer.life > 30
    end
  end

  describe "attack/1" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      :ok
    end

    test "when it's the player turn, executes the attack action to decrease the opponent life points" do
      # forcing change the turn to player
      Game.update(%{Game.info() | turn: :computer})

      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      assert Game.info().computer.life < 100
    end

    test "when it's the computer turn, executes the attack action to decrease the opponent life points" do
      # forcing change the turn to computer
      Game.update(%{Game.info() | turn: :player})

      capture_io(fn ->
        Actions.attack(:move_avg)
      end)

      assert Game.info().player.life < 100
    end
  end

  describe "fetch_move/1" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      :ok
    end

    test "when the given move exists for the player, returns the move key" do
      assert {:ok, :move_rnd} = Actions.fetch_move(:kick)
    end

    test "when the given move doesn't exist for the player, returns error" do
      assert {:error, :invalid_move} = Actions.fetch_move(:invalid_move)
    end
  end
end
