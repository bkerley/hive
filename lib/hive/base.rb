module Hive
  class Base
    attr_accessor :directory
    attr_accessor :username
    attr_accessor :actor
    attr_accessor :repo
    def initialize(directory, username)
      self.directory = directory
      self.username = username
      self.actor = Grit::Actor.new(username, "#{username}@hive.invalid")
      select_or_create_repository
      check_repository_schema
    end
    
    # count the number of cells in this hive
    def [](cell_name)
      cell = Cell.select_or_create_cell(cell_name, self)
      
    end
    
    private
    
    def file_for_cell(cell_name)
      Digest::SHA1.hexdigest(cell_name)
    end
    
    def select_or_create_repository
      tried_repo = Grit::Repo.new(self.directory, :is_bare=>true)
      self.repo = tried_repo
      return
    rescue Grit::NoSuchPathError => e
      create_repository
    rescue Grit::InvalidGitRepositoryError => e
      create_repository
    end
    
    def create_repository
      FileUtils::mkdir_p(self.directory)
      self.repo = Grit::Repo.init_bare(self.directory, {:bare=>true}, {:is_bare=>true})
    end
  end
end