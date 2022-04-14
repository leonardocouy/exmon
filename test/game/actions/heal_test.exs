defmodule ExMon.Game.Actions.HealTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Heal

  describe "heal_life/1" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      {:ok, player: player, computer: computer}
    end

    test "when the life for the given player is less than 100, increase player life points",
         %{player: player} do
      # forcing life decrease
      Game.update(%{Game.info() | player: %{player | life: 70}})

      messages =
        capture_io(fn ->
          Heal.heal_life(:player)
        end)

      assert Game.info().player.life > 70
      assert messages =~ ~r/The player healed itself to \d+ life points/
    end

    test "when the life for the given player is equal to 100, does not increase player life points" do
      messages =
        capture_io(fn ->
          Heal.heal_life(:player)
        end)

      assert Game.info().player.life == 100
      assert messages =~ ~r/The player healed itself to 100 life points/
    end
  end
end
