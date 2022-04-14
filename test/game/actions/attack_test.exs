defmodule ExMon.Game.Actions.AttackTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Actions.Attack

  describe "attack_opponent/2" do
    setup do
      player = Player.build("Leo", :kick, :punch, :heal)
      computer = Player.build("Crazy Rooster", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      :ok
    end

    test "with the given move, decrease life points for the given opponent" do
      messages =
        capture_io(fn ->
          Attack.attack_opponent(:computer, :move_rnd)
        end)

      assert Game.info().computer.life < 100
      assert messages =~ ~r/The Player attacked the computer dealing \d+ damage/
    end
  end
end
