# RubyQL
## A query language for ruby hashes

RubyQL is a query language designed for very flexible rest apis or plain ruby hashes.

Example:
``` ruby
  class UserQuery < RubyQL
    def query
      User.find_by(query_params).attributes
    end
  end
```

The class we created overwrites the query method, to provide a custom mechanism which should return a hash. 
IMPORTANT: `.attributes` is necessary for ActiveRecord, only returning the actual hash, not the ActiveModel object.


Usage:
```
  query = UserQuery.new({"username"=>"", "firstname"=>"", "lastname"=>"", "email"=>"niklas.hanft@outlook.com"})
  query.execute
  => {"firstname"=>"Niklas", "lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com"}
```

As you can see we left the wanted attributes blank, so rubyql will fill them out, if they exist. 