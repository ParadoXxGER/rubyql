require 'spectr'
require_relative '../lib/rubyql'

Spectr.new.test 'Test the queryable class' do |test|
  class UserQuery < RubyQL
    def query
      { 'username' => 'paradoxxger',
        'firstname' => 'Niklas',
        'lastname' => 'Hanft',
        'email' => 'niklas.hanft@outlook.com' }
    end
  end

  test.assume('The response is a hash', true) do
    UserQuery.new('lastname' => '', 'email' => 'niklas.hanft@outlook.com').execute.is_a?(Hash)
  end

  assumed_result = { 'firstname' => 'Niklas', 'lastname' => 'Hanft', 'email' => 'niklas.hanft@outlook.com' }

  test.assume('The response equals the given hash', assumed_result) do
    UserQuery.new('firstname' => '', 'lastname' => '', 'email' => 'niklas.hanft@outlook.com').execute
  end

  assumed_result = { 'lastname' => 'Hanft', 'email' => 'niklas.hanft@outlook.com' }

  test.assume('The response equals the given hash', assumed_result) do
    UserQuery.new('lastname' => '', 'email' => 'niklas.hanft@outlook.com').execute
  end

  test.assume('The query_params are only the email', 'email' => 'niklas.hanft@outlook.com') do
    UserQuery.new('lastname' => '', 'email' => 'niklas.hanft@outlook.com').query_params
  end
end
