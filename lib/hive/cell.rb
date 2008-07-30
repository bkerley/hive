module Hive
  class Cell < Hash
    def self.select_or_create_cell(cell_name, repo)
      filename = file_for_cell(cell_name)
      file = repo.tree/filename
      file = Cell.new(cell_name, repo)
    end
    
    def self.file_for_cell(cell_name)
      return Digest::SHA1.hexdigest(cell_name)
    end
    
    attr_accessor :name
    attr_accessor :repo
    attr_accessor :filename
    
    def initialize(cell_name, repo)
      self.name = cell_name
      self.filename = Cell.file_for_cell name
      super()
    end
  end
end