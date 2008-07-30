module Hive
  class Hive
    attr_accessor :directory
    attr_accessor :username
    attr_accessor :repo
    def initialize(directory, username)
      self.directory = directory
      self.username = username
      select_or_create_repository
    end
    
    private
    def select_or_create_repository
      tried_repo = Grit::Repo.new(self.directory)
      self.repo = tried_repo
      return
    rescue Grit::NoSuchPathError => e
    rescue Grit::InvalidGitRepositoryError => e
      FileUtils::mkdir_p(self.directory)
      tried_repo = Grit::Repo.init_bare(self.directory)
      self.repo = tried_repo
      return
    end
  end
end