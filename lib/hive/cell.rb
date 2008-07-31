module Hive
  class Cell < Hash
    def self.select_or_create_cell(cell_name, hive)
      filename = file_for_cell(cell_name)
      file = hive.repo.tree/filename
      if file
        return recover_cell_from_file(cell_name, hive, file)
      else
        return Cell.new(cell_name, hive)
      end
    end
    
    def self.file_for_cell(cell_name)
      return Digest::SHA1.hexdigest(cell_name)
    end
    
    def self.recover_cell_from_file(cell_name, hive, file)
      c = Cell.new(cell_name, hive)
      c.merge YAML::load(file.data)
    end
    
    attr_accessor :name
    attr_accessor :hive
    attr_accessor :filename
    
    def initialize(cell_name, hive)
      self.name = cell_name
      self.filename = Cell.file_for_cell name
      self.hive = hive
      super()
    end
    
    def save
      serialized = YAML::dump(self)
      i = self.hive.repo.index
      i.add(self.filename, serialized)
      parent = self.hive.repo.commits.last.id
      prev_tree = self.hive.repo.commits.first.tree.id
      i.commit("Saved #{self.name}", [parent], self.hive.actor, prev_tree)
    end
    
    def history
      self.hive.repo.commits.map{|c|c.tree.contents}.flatten.select{|c|c.name == self.filename}
    end
  end
end