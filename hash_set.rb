class HashSet
  attr_accessor :store

  def initialize (hash = {})
    @store = hash
  end

  def insert(el)
    @store[el] = true
  end

  def include?(el)
    !!@store[el]
  end

  def delete(el)
    result = include?(el)
    @store.delete(el)
    result
  end

  def to_a
    @store.keys
  end

  def union(set2)
    HashSet.new( @store.merge(set2.store) )
  end

  def intersect(set2)
    new_hash = HashSet.new
    elements = set2.to_a
    elements.each do |el|
      new_hash.insert(el) if include?(el)
    end
    new_hash
  end

  def minus(set2)
    new_hash = HashSet.new
    elements = self.to_a
    elements.each do |el|
      new_hash.insert(el) unless set2.include?(el)
    end
    new_hash
  end
end
