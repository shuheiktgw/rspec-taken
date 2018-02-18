require 'rspec/taken'

desc 'Transpile RSpec/Given files into RSpec.'

task :taken do
  ::Rspec::Taken.taken(ARGV.last)
  ARGV.slice(1,ARGV.size).each{|v| task v.to_sym do; end }

  puts 'Success!'
end
