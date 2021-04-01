# frozen_string_literal: true

require 'rake/testtask'

# To use with a seed, run `bundle exec rake test SEED=1234`
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/*_test.rb'
end

task default: :test
