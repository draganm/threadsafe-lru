# ThreadSafeLru

Thread safe LRU Cache implementation in Ruby compatible with Java's Memory Model.

## Installation

Add this line to your application's Gemfile:

    gem 'threadsafe-lru'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install threadsafe-lru

## Usage

	# initialize cache with maximum size of 200
	cache_size=200
	fib_cache=ThreadSafeLru::LruCache.new 200

	# fetch fibonacci of 42 from cache. only first execution will perform computation (evaluate block)	
	fib_200 =fib_cache.get(42) {|key| fib(key)}
	
	# drop key 42 from the cache
	fib_cache.drop(42)
	
	# clear cache by dropping all cached values
	fib_cache.clear()	

## Thread safety

	There are two level of locking within the cache.
	Cache lock makes sure that cache structure can be accessed only by one thread at the time
	Value lock makes sure that only one thread produces a value for given key at the time. 
	All other threads interested in obtaining the value for the key are waiting for the first thread to finish
	
## Testing
	
	ThreadSafeLru has been tested with MRI 1.9.3, Jruby 1.6.2, Jruby 1.7.0.preview1 and Jruby 1.7.0.preview2  
			

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
