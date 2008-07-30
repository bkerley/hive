module Hive
  module Schema
    def check_repository_schema
      schema = self.repo.tree/'hive_schema'
      schema = build_schema if schema.nil?
    end
    
    private
    def build_schema
      schema = {:version=>1}
      index = self.repo.index
      index.add 'hive_schema', YAML::dump(schema)
      index.commit('Hive: creating schema', nil, self.actor)
    end
  end
end