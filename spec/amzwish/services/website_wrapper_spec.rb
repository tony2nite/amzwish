# encoding: UTF-8
require 'spec_helper'

module Amzwish
  module Services 
    PREVENT_WEB_REQUESTS = false
  
    describe WebsiteWrapper do 
    
      let(:mock_client){ mock("rest_client")}
      let(:fixture){ WebsiteWrapper.new(mock_client) }
       
      describe "getting wishlist id" do
        describe "wishlist not found" do
          it "should return an empty array" do
            mock_client.should_receive(:post).with("address@email.com").and_return({:code => 200, :response => ""})
            fixture.find_for("address@email.com").should == []
          end
        end
        describe "single wishlist found" do
          it "should return an array with one wishlist" do
            mock_client.should_receive(:post).with("address@email.com").and_return(
              { :code => 302, 
                :headers=> {
                  :location=>"http://www.amazon.co.uk/gp/registry/registry.html/276-3987950-0414363?ie=UTF8&type=wishlist&id=WISH_LIST_ID"}
                  })
            result = fixture.find_for("address@email.com")
            result.size.should == 1
            result[0].class.should == Wishlist
          end
        end
      end
    
      describe "getting wishlist content html" do
        describe "getting page 1" do
          it "should return the page as a string" do
            mock_client.should_receive(:get).with("WISH_LIST_ID", 1).and_return("Page Content")
            fixture.get_page("WISH_LIST_ID", 1).should == "Page Content"
          end
        end    
      end 
    
      context "examples that make actual web requests" do 
        let(:fixture){ WebsiteWrapper.new() }
        example "get wishlist html" do
          fixture.get_page("34VGL4IX1RMYO", 1).should =~ /Chris Tinning/
        end
        
        example "get wishlist" do
          wishlists = fixture.find_for("anthony@sunandair.com")
          wishlists.should be_kind_of(Array)
          wishlists.count.should > 0
          # wishlists[0].list_id.should == "34VGL4IX1RMYO" 
          wishlists[0].list_id.should == "24UTKOOHVQDNV" 
          wishlists[1].list_id.should == "1RDI3QRP45BTS"
        end

        example "get book find_book_for" do
          book = fixture.find_book_for("B004VS866M")
          book.asin.should == "B004VS866M"
          book.price.should > 0 
          book.title.should == "Life And Fate"
     
          book = fixture.find_book_for("0571135390")
          book.price.should > 0

          book = fixture.find_book_for("B005E87GLY")
          book.price.should > 0

          book = fixture.find_book_for("B003YMNVC0")
          book.price.should_not be_nil
        end
      end unless PREVENT_WEB_REQUESTS                          
    end
  end           
end