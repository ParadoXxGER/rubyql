# RubyQL
## A query language for ruby hashes

[![Gem Version](https://badge.fury.io/rb/rubyql.svg)](https://badge.fury.io/rb/rubyql)

RubyQL is a query language designed for very flexible rest apis or plain ruby hashes.

RubyQL loves it when its used together with ActiveRecord 🤤

Example:
``` ruby
require 'rubyql'

class UserQuery < RubyQL
  def query
    result = User.find_by(query_params)
    result.attributes unless result.nil?
  end
end
```

The class we created overwrites the query method, to provide a custom mechanism which should return a hash. `query_params` is 
the hash which holds the provided parameter, like `WHERE` in SQL.
 
**IMPORTANT**: `.attributes` is necessary for ActiveRecord, only returning the actual hash, not the ActiveModel object.

## Usage:
``` ruby
UserQuery.new({"firstname"=>"", "lastname"=>"", "email"=>"niklas.hanft@outlook.com"}).execute
=> {"firstname"=>"Niklas", "lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com"}

UserQuery.new({"lastname"=>"", "email"=>"niklas.hanft@outlook.com"}).execute
=> {"lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com"}

UserQuery.new({"lastname"=>"", "email"=>"", "id"=>1}).execute
=> {"lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com", "id"=>1}
```

As you can see we left the wanted attributes blank, so rubyql will fill them out, if they exist.

For a better understanding another plain ruby example:

``` ruby
require 'rubyql

class PlainQuery < RubyQL
  def query
    {"firstname"=>"Niklas", "lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com", "id"=>1337, "another_attribute"=>"Hello World"}
  end
end
```

The method is only returning a simple hash. Now we can execute queries:

``` ruby
PlainQuery.new({"firstname"=>"", "lastname"=>"", "email"=>"niklas.hanft@outlook.com", "id"=>""}).execute
=> {"firstname"=>"Hanft", "lastname"=>"Niklas", "email"=>"niklas.hanft@outlook.com", "id"=>1337}

PlainQuery.new({"email"=>"niklas.hanft@outlook.com", "id"=>"", "another_attribute"=>""}).execute
=> {"email"=>"niklas.hanft@outlook.com", "id"=>1337, "another_attribute"=>"Hello World"}
```

As this is static, it doesn't really make sense, but for understanding it might be ok to use it this way. But mainly it
should be used with a database orm or some dynamic functions which return hashes.

## Advanced usage:

A typical API in Rails

``` ruby
module Api
  module V1
    class UserQueryController < ApiController
      before_action :user_params

      def execute
        render json: UserQuery.new(user_params).execute.to_json
      end

      private

      def user_params
        params.permit(:username, :firstname, :email, :id, :lastname, :posts, :created_at).to_h
      end

    end
  end
end
```

The Query class

``` ruby
require 'rubyql'

class UserQuery < RubyQL
  def query
    result = User.find_by(query_params)
    result.attributes unless result.nil?
  end
end
```

Routing:

``` ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
    post '/user-query', to: 'user_query#execute'
  end
end
```

A request:

``` json
POST /api/v1/user-query
{
	"email": "niklas.hanft@outlook.com",
	"firstname":"",
	"id":"",
	"created_at":"",
	"lastname":""
}
```

The response:

``` json
{
    "id": 1,
    "firstname": "Niklas",
    "lastname": "Hanft",
    "created_at": "2017-11-21T07:10:46.953Z",
    "email": "niklas.hanft@outlook.com"
}
```

A second request:

``` json
POST /api/v1/user-query
{
	"email": "niklas.hanft@outlook.com",
	"firstname":""
}
```

The response:

``` json
{
    "id": 1,
    "firstname": "Niklas"
}
```


