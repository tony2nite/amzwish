# encoding: UTF-8
require 'spec_helper'
 
module Amzwish
  describe Book do
    describe "equality" do
      let(:fixture){ Book.new("123", "Title", 50) }
      describe "is based on asin number" do
        example "books with the same asin number are equal" do
          (fixture == Book.new("123", "Title")).should == true
        end
        example "books with different asin numbers are not equal" do
          (fixture == Book.new("321", "Title")).should == false 
        end
        example "books are not equal to things that are not books" do
          (fixture == "Title").should == false
        end
        example "books are sorted by price" do
          high = Book.new("456", "Title", 100)
          (high <=> fixture).should == 1
          
          low = Book.new("789", "Title", 25)
          (low <=> fixture).should == -1

          same = Book.new("101112", "Title", 50)
          (same <=> fixture).should == 0
        end
      end
    end
  end           
end