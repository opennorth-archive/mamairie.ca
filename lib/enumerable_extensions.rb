module Enumerable
  def in_two
    each_slice((size + 1) / 2)
  end
  def in_four
  	each_slice((size + 2) / 4)
  end
end
