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
    attr_accessor :parent
    attr_accessor :tree
    
    def initialize(cell_name, hive)
      self.name = cell_name
      self.filename = Cell.file_for_cell name
      self.hive = hive
      self.parent = hive.repo.commits.last.id
      self.tree   = hive.repo.tree.id
      super()
    end
    
    # Merges in changes from the hive as it is right now (will clobber changed and unsaved fields)
    def reload
      self.parent = hive.repo.commits.last.id
      self.tree   = hive.repo.tree.id
      file = self.hive.repo.tree/self.filename
      self.merge_over YAML::load(file.data)
    end
    
    # Saves and attempts to merge in changes since the last reload or creation of this cell
    def save
      my_parent = self.parent
      existing_parent = hive.repo.commits.last.id
      existing_tree = hive.repo.tree
      parent_arr = [my_parent]
      prev_tree = self.tree
      
      i = self.hive.repo.index
      i.add(self.filename, YAML::dump(self))
      i.commit("Saved #{self.name}", parent_arr, self.hive.actor, prev_tree)
      
      if my_parent != existing_parent
        new_tree = hive.repo.tree.id
        parent_arr = [parent, existing_parent]
        file = existing_tree/self.filename
        existing_hash = YAML::load(file.data)
        self.merge_over existing_hash
        i = self.hive.repo.index
        i.add(self.filename, YAML::dump(self))
        i.commit("Merged #{self.name}", parent_arr, self.hive.actor, new_tree)
      end
      
      self.parent = hive.repo.commits.last.id
      self.tree   = hive.repo.tree.id
      self.reload
    end
    
    # Returns an array of this file's historic blobs
    def history
      self.hive.history.map{|c|c.tree.contents}.flatten.select{|c|c.name == self.filename}
    end
    
    # Instead of replacing my values with the given hash, only load values I don't have.
    def merge_over(hash)
      self.replace(hash.merge(self))
    end
    
    def inspect
      hash_inspect = super
      name_portion = self.name ? %Q{"#{self.name}"@"#{self.filename}"} : 'UNTITLED'
      %Q{#<Hive::Cell #{name_portion} #{hash_inspect}>}
    end
  end
end