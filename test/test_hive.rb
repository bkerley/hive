require File.expand_path(File.dirname(__FILE__) + "/test_helper.rb")

class TestHive < Test::Unit::TestCase
  include Hive
  
  context 'with a new hive' do
    setup do
      setup do
        hive_dir = File.expand_path(File.dirname(__FILE__) + "/../tmp/test_dir.git")
        @hive = Hive.new(hive_dir, 'test_user')
      end
      teardown do
        FileUtils::rm_rf(@hive.directory)
      end
      should 'make a new hive' do
        assert_instance_of Hive, new_hive
      end
    end
  end
  
  context 'with nothing' do
    setup do
      @hive_dir = File.expand_path(File.dirname(__FILE__) + "/../tmp/test_dir.git")
    end
    teardown do
      FileUtils::rm_rf(@hive_dir)
    end
    should 'make a new hive' do
      new_hive = Hive.new(@hive_dir, 'test_user')
      assert_instance_of Hive, new_hive
    end
    context 'but a directory' do
      setup do
        FileUtils::rm_rf(@hive_dir)
        FileUtils::mkdir_p(@hive_dir)
      end
      
      should 'make a new hive' do
        new_hive = Hive.new(@hive_dir, 'test_user')
        assert_instance_of Hive, new_hive
      end
    end
  end
end

