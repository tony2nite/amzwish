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

          noprice = Book.new("13141516", "Title")
          (noprice <=> fixture).should == 0           # not sure what correct behaviour should be here actuallys
  
          same = Book.new("101112", "Title", 50)
          (same <=> fixture).should == 0
        end
      end
    end
    
    describe "collections" do
      books = []
      books << Book.new('0571135390')
      books << Book.new('B004VS866M')
      
      it "syncs collections of books" do 
        books[0].price.should == nil
        books[1].price.should == nil
        books.each { |b|
          b.sync()
        }
        books[0].price.should_not == nil
        books[1].price.should_not == nil
      end
    end
    
    describe "sync with website data" do
      let(:mock_rest_service){ mock_rest_service_wrapper( %w{ single-book-item.html }, "0571135390") }
      let(:wrapper){ Services::WebsiteWrapper.new( mock_rest_service ) }
      
      it "returns book detail" do
        book = Book.new( "0571135390", "", nil, wrapper )
        book.sync()
        book.title.should == "The Unbearable Lightness of Being"     
        book.price.should == 4.76
        book.asin.should == "0571135390"
      end
    end
    
   def mock_rest_service_wrapper (html_files, asin = "ASIN") 
      mock_rest_service = mock(Services::RestClientWrapper)
      html_files.each_with_index do |f, i|
        page = open(File.join(PROJECT_DIR, "samples","uk", f ), "r:UTF-8").read
        mock_rest_service.should_receive(:get_book).with( asin ).and_return(page) 
      end
      mock_rest_service
    end
  end           
end