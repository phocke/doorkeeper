require 'factory_girl'

FactoryGirl.definition_file_paths << File.join(ENGINE_RAILS_ROOT, 'spec/factories')

FactoryGirl.find_definitions
