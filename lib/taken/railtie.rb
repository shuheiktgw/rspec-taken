module Taken
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/taken.rake'
    end
  end
end
