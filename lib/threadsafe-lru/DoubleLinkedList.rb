module ThreadSafeLru
  class ListNode
    def initialize value
      @value=value
    end

    def insert_between prev_node, next_node      
      self.next=next_node
      self.prev=prev_node
      prev_node.next=self
      next_node.prev=self      
      self
    end

    def remove
      self.prev.next=self.next
      self.next.prev=self.prev
      self.next=nil
      self.prev=nil
    end

    attr_reader :value
    attr_accessor :next
    attr_accessor :prev

  end

  class DoubleLinkedList

    def initialize
      @head=ListNode.new "head"
      @tail=ListNode.new "tail"
      @head.next=@tail
      @tail.prev=@head      
    end


    def add_to_head value
      new_node=ListNode.new value
      new_node.insert_between @head,@head.next
      new_node
    end

    def bump_to_top node
      node.remove
      node.insert_between @head,@head.next
    end

    def remove_last
      node=@tail.prev
      node.remove
      node
    end

    def clear
      @head.next=@tail
      @tail.prev=@head
    end


    def to_a
      result=[]
      current=@head.next
      while current != @tail
        result << current.value
        current=current.next
      end
      result
    end

  end
end
