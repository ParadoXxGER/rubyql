require 'spectr'
require_relative '../lib/rubyql'
require_relative '../lib/init_error'

class UserQuery < RubyQL
  def query
    { 'username' => 'paradoxxger',
      'firstname' => 'Niklas',
      'lastname' => 'Hanft',
      'email' => 'niklas.hanft@outlook.com' }
  end
end

Spectr.new.test 'Test the UserQuery class' do |test|
  test.assume('The response is a hash', Hash) do
    UserQuery.new('lastname' => '', 'email' => 'niklas.hanft@outlook.com').execute.class
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

Spectr.new.test 'Test the wrong initialization of the UserQuery class' do |test|
  test.assume('The initialization should fail with a String', InitError) do
    begin
      UserQuery.new('WrongAttribute')
    rescue InitError => e
      e.class
    end
  end

  test.assume('The initialization should fail with an Integer', InitError) do
    begin
      UserQuery.new(1337)
    rescue InitError => e
      e.class
    end
  end
end
