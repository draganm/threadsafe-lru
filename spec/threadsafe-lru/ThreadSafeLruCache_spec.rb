require 'threadsafe-lru/ThreadSafeLruCache'
require 'thread'

module ThreadSafeLru
  describe LruCache do

    subject {LruCache.new(3){|key| "value: #{key}"}}

    describe :get do
      it "should cache single value" do
        subject.get(:one){1}.should == 1
        subject.get(:one){2}.should == 1
      end

      it "should drop least used value" do
        subject.get(:one){1}.should == 1
        subject.get(:two){2}.should == 2
        subject.get(:three){3}.should == 3
        subject.get(:four){4}.should == 4

        subject.get(:one){99}.should == 99
        subject.get(:three){99}.should == 3
        subject.get(:four){99}.should == 4
        subject.get(:two){99}.should == 99
      end

      it "should not corrupt state in highly concurrent situation" do

        cache=subject

        threads=(1..100).map do
          Thread.new do
            (0..2000).each do
              random=rand(2000)
              cache.get(random) {random}.should == random
            end
          end
        end
        
        threads.each {|thread| thread.join}

      end

      it "should make second thread wait for the first requesting thread to value" do

        (1..100).each do

          q1=Queue.new
          q2=Queue.new

          cache=subject

          t1=Thread.new do
            cache.get(:one) {
              q1.pop
              q2 << 1
              "thread1"
            }
          end

          t2=Thread.new do
            q2.pop
            cache.get(:one) {
              "thread2"
            }
          end

          q1<<1

          t1.join
          t2.join

          cache.get(:one).should == "thread1"

          cache.clear

        end
      end

    end

    describe :clear do
      it "should drop all cached values" do
        subject.get(:one){1}.should == 1
        subject.get(:one){2}.should == 1
        subject.clear
        subject.get(:one){2}.should == 2
      end
    end

    describe :drop do

      before do
        subject.get(:one){"one"}
        subject.get(:two){"two"}
      end

      context "when there is a cached value" do

        it "should drop that cached value" do
          subject.get(:one).should == "one"
          subject.get(:two).should == "two"

          subject.drop(:one)

          subject.get(:one){"newone"}.should == "newone"
          subject.get(:two).should == "two"
        end

      end

      context "when value is not cached" do
        it "should not drop anything" do
          subject.drop(:three)
          subject.get(:one){"newone"}.should == "one"
          subject.get(:two){"newtwo"}.should == "two"
        end

      end

    end

  end

end