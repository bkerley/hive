module Hive
  class Base
    attr_accessor :directory
    attr_accessor :username
    attr_accessor :actor
    attr_accessor :repo
    
    # create or open the Hive::Base from the specified +directory+, and use +username+ for commit messages
    def initialize(directory, username)
      self.directory = directory
      self.username = username
      self.actor = Grit::Actor.new(username, "#{username}@hive.invalid")
      select_or_create_repository
      check_repository_schema
    end
    
    # return the Hive::Cell with the given name
    def [](cell_name)
      cell = Cell.select_or_create_cell(cell_name, self)
      
    end
    
    # history of the entire hive
    def history
      self.repo.commits('master', false)
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