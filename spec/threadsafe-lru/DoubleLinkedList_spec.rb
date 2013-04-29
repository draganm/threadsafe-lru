require 'threadsafe-lru'

module ThreadSafeLru
  describe DoubleLinkedList do

    describe :clear do
      it "should clear all values" do
        subject.add_to_head("value1")
        subject.clear
        subject.to_a.should == []
      end
    end

    describe :add_to_head do
      it "should append node to head" do
        subject.add_to_head("value1").should be_a ListNode
        subject.to_a.should == ["value1"]
        subject.add_to_head("value0").should be_a ListNode
        subject.to_a.should == ["value0","value1"]
      end
    end

    describe :remove_last do
      it "should remove last element from the linked list" do
        subject.add_to_head("v1")
        subject.add_to_head("v2")
        subject.remove_last
        subject.to_a.should == ["v2"]
      end
    end

    describe :bump_to_top do
      it "should move node to the top of the list" do
        last=subject.add_to_head("v1")
        first=subject.add_to_head("v2")
        subject.bump_to_top last
        subject.to_a.should == ["v1","v2"]
      end
    end
  end

  describe ListNode do
    subject {ListNode.new "value"}

    describe :insert_between do
      let(:prev_node) {ListNode.new "prev"}
      let(:next_node) {ListNode.new "next"}

      it "should insert node in the chain between prev and next" do
        subject.insert_between(prev_node,next_node)
        subject.prev.should == prev_node
        subject.next.should == next_node
        prev_node.next.should == subject
        next_node.prev.should == subject
      end
    end

    describe :remove do
      let(:prev_node) {ListNode.new "prev"}
      let(:next_node) {ListNode.new "next"}
      it "should remove itself from the chain" do
        subject.insert_between prev_node, next_node
        subject.remove
        subject.next.should == nil
        subject.prev.should == nil

        prev_node.next.should == next_node
        next_node.prev.should == prev_node

      end
    end

  end



end
