defmodule ExMon.PlayerTest do
  use ExUnit.Case

  alias ExMon.Player

  describe "build/4" do
    test "returns a Player struct" do
      assert Player.build("Leo", :kick, :punch, :heal) == %Player{
               life: 100,
               moves: %{
                 move_avg: :punch,
                 move_heal: :heal,
                 move_rnd: :kick
               },
               name: "Leo"
             }
    end
  end
end
