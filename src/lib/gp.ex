defmodule Sof.Gp do
  def get(item_level, slot_mod) do
    rarity = 4
    pow = item_level / 26 + (rarity - 4)
    17.213 * :math.pow(2, pow) * slot_mod
  end
end
