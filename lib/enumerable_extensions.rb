module Enumerable
  def in_two
    each_slice((size + 1) / 2)
  end
end
