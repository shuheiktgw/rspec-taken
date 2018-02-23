require 'rspec/taken'

desc 'Transpile RSpec/Given files into RSpec.'

task :taken do
  begin
    path = ARGV.last == 'true' ? ARGV[-2] : ARGV.last
    succeeded, failed = ::Rspec::Taken.taken(path, ARGV.last == 'true')

    unless succeeded.empty?
      puts "\e[32m[Success]\e[0m Successfully transpiled RSpec files below."
      succeeded.each do |f|
        puts "[File Name] #{f}"
      end
      puts ''
    end

    if failed.empty?
      puts 'All the files are successfully transpiled! Yay!'
    else
      failed.each do |f|
        puts "\e[31m[Fail]\e[0m Some files seem to have problem with transpilation...."
        puts "[File name]     #{f.file_name}"
        puts "[Error message] #{f.message}"
        puts ''
        puts ''
        puts 'If you encountered any bugs, I would really appreciate it if you would report it to as an issue!'
        puts 'Link: https://github.com/shuheiktgw/rspec-taken/issues'
        puts ''
        puts 'Or you might want to send me a PR!'
        puts 'Link: https://github.com/shuheiktgw/rspec-taken/pulls'
      end
    end
  end
end
