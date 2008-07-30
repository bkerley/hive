require File.expand_path(File.dirname(__FILE__) + "/test_helper.rb")

class TestHive < Test::Unit::TestCase
  
  context 'a new hive' do
    setup do
      hive_dir = File.expand_path(File.dirname(__FILE__) + "/../tmp/test_dir")
      @hive = Hive::Base.new(hive_dir, 'test_user')
    end
    teardown do
      FileUtils::rm_rf(@hive.directory)
    end
    should 'be a hive' do
      assert_instance_of Hive::Base, @hive
    end
    should 'have a repo' do
      assert_instance_of Grit::Repo, @hive.repo
    end
    
    should 'be able to create a cell' do
      test_cell = @hive['test']
      assert_kind_of Hash, test_cell
    end
  end
  
  context 'with nothing' do
    setup do
      @hive_dir = File.expand_path(File.dirname(__FILE__) + "/../tmp/test_dir")
    end
    teardown do
      FileUtils::rm_rf(@hive_dir)
    end
    should 'make a new hive' do
      new_hive = Hive::Base.new(@hive_dir, 'test_user')
      assert_instance_of Hive::Base, new_hive
    end
    context 'but a directory' do
      setup do
        FileUtils::rm_rf(@hive_dir)
        FileUtils::mkdir_p(@hive_dir)
      end
      
      should 'make a new hive' do
        new_hive = Hive::Base.new(@hive_dir, 'test_user')
        assert_instance_of Hive::Base, new_hive
      end
    end
  end
end

