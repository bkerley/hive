require File.expand_path(File.dirname(__FILE__) + "/test_helper.rb")

class CreationTest < Test::Unit::TestCase
  include Hive
  context 'with nothing' do
    setup do
      @hive_dir = File.expand_path(File.dirname(__FILE__) + "/tmp/test_dir")
      FileUtils::mkdir_p(@hive_dir)
    end
    teardown do
      FileUtils::rm_rf(@hive_dir)
    end
    should 'make a new hive' do
      new_hive = Hive.new(@hive_dir, 'test_user')
      assert_instance_of Hive, new_hive
    end
  end
end

