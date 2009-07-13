class String
  def starts_with?(other)
    head = self[0, other.to_s.length]
    head == other
  end

  def ends_with?(other)
    tail = self[-1 * other.to_s.length, other.to_s.length]
    tail == other
  end
end
