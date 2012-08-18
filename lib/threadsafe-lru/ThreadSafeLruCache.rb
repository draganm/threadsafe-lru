require 'thread'

module ThreadSafeLru
  class LruCache
    def initialize size, &block
      @size=size
      @cached_values={}
      @factory_block=block
      @recently_used=[]
      @lock=Mutex.new
    end

    def size
      @recently_used.size
    end

    
    def drop key
      @lock.synchronize do
        @cached_values.delete key
        @recently_used.delete key
      end
    end
      
    
    def clear
      @lock.synchronize do
        @cached_values.clear
        @recently_used.clear
      end
    end
    
    def get key, &block
      node=nil
      @lock.synchronize do
        node=get_node(key)
      end
      node.get_value(block ? block : @factory_block)
    end

    private

    def get_node key
      if @cached_values.has_key?(key)
        @recently_used.delete(key)
        @recently_used << key
      else
        while (@recently_used.size >= @size) do
          dropped=@recently_used.shift
          @cached_values.delete(dropped)
        end
        node=Node.new key
        @cached_values[key]=node
        @recently_used << key
      end

      @cached_values[key]
    end

  end

  class Node
    def initialize key
      @key=key
      @produced=false
      @value=nil
      @lock=Mutex.new
    end

    def get_value block
      @lock.synchronize do
        unless (@produced)
          @value=block.call @key
          @produced=true
        end
        @value
      end
    end
  end

end
