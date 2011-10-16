# encoding: UTF-8
require 'spec_helper'
 
module Amzwish
  describe Book do
    describe "equality" do
      let(:fixture){ Book.new("123", "Title") }
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
      end
    end
  end           
end