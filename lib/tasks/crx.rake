require 'crxmake'
require 'coffee-script'
require 'rest-client'
require 'pry'

desc 'create chrome extension package'
task :crx do
  Rake::Task["crx:packaging"].invoke
end

namespace :crx do
  tmp_dir = "./.tmp"

  task :packaging => [:compile_coffee, :libraries, :manifest]  do
    CrxMake.make(
      ex_dir: tmp_dir,
      crx_output: 'isuzu.crx',
      pkey: 'crx/key.pem',
      verbose: true
      )
  end

  task :manifest do
    FileUtils.copy "crx/manifest.json", tmp_dir
  end

  task :libraries do
    [
      "http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"
    ].each do |url|
      filename = File.join tmp_dir, File.basename(url)
      File.open(filename, 'w') { |f| f.puts RestClient.get(url) }
    end
  end

  task :compile_coffee do
    FileUtils.mkdir_p(tmp_dir) unless File.exists?(tmp_dir)

    js_files = Dir["./crx/**/*.coffee"].map do |file|
      output_file = file.gsub(/\.\/crx/, tmp_dir).gsub(/\.coffee/, '.js')
      output_dir = File.dirname(output_file)
      FileUtils.mkdir_p(output_dir) unless File.exists?(output_dir)
      File.open(output_file, 'w') do |f|
        f.puts CoffeeScript.compile(File.read(file))
      end
      output_file
    end
    js_files
  end
end
