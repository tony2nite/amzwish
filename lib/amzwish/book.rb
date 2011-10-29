module Amzwish
  class Book
    attr_accessor :asin,:title,:price
    
    
    def initialize(asin, title = "", price = nil, website = Services::WebsiteWrapper.new)
      @asin = asin
      @title = title 
      @price = price
      @website = website
    end
    
    def sync
      b = @website.find_book_for(asin)
      @price = b.price
      @title = b.title
    end
    
    def ==(other)
      other.respond_to?(:asin) && 
        self.asin == other.asin
    end
    
    def <=>(other)
      compare = 0;
      unless self.price.nil? || other.price.nil?
        compare = self.price <=> other.price
      end
      return compare
    end
    
    def to_s
      "#{title}(#{asin}) #{price}"
    end
  end
end