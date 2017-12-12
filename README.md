# RubyQL
## A query language for ruby hashes

RubyQL is a query language designed for very flexible rest apis or plain ruby hashes.

*RubyQL loves it, being used with ActiveRecord 🤤*

Example:
``` ruby
  class UserQuery < RubyQL
    def query
      User.find_by(query_params).attributes
    end
  end
```

The class we created overwrites the query method, to provide a custom mechanism which should return a hash. `query_params` is 
the hash which holds the provided parameter, like `WHERE` in SQL." **IMPORTANT**: `.attributes` is necessary for 
ActiveRecord, only returning the actual hash, not the ActiveModel object.

Usage:
```
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
  class PlainQuery < RubyQL
    def query
      {"firstname"=>"Niklas", "lastname"=>"Hanft", "email"=>"niklas.hanft@outlook.com", "id"=>1337, "another_attribute"=>"Hello World"}
    end
  end
```

The method is only returning a simple hash. Now we can execute queries:

```
  PlainQuery.new({"firstname"=>"", "lastname"=>"", "email"=>"niklas.hanft@outlook.com", "id"=>""}).execute
  => {"firstname"=>"Hanft", "lastname"=>"Niklas", "email"=>"niklas.hanft@outlook.com", "id"=>1337}
  
  PlainQuery.new({"email"=>"niklas.hanft@outlook.com", "id"=>"", "another_attribute"=>""}).execute
  => {"email"=>"niklas.hanft@outlook.com", "id"=>1337, "another_attribute"=>"Hello World"}
```

As this is static, it doesn't really make sense, but for understanding it might be ok to use it this way. But mainly it
should be used with a database or some dynamic function which return some hashes.


