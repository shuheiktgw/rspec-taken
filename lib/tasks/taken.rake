require 'rspec/taken'

desc 'Transpile RSpec/Given files into RSpec.'

task :taken do
  ::Rspec::Taken.taken(ARGV.last)
  puts "\e[32m[Success]\e[0m Transpiled RSpec files below."

  ::Rspec::Taken.files.each do |f|
    puts f
  end
end
