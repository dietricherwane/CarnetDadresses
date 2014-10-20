class AddressBookTitlesController < ApplicationController

  def titles
    @titles_options = "<select id = 'adress_book_address_book_title_id' class = 'form-control' name = 'adress_book[address_book_title_id]'><option>-Veuillez choisir un titre-</option>"
    @titles = AddressBookTitle.where("address_book_title_category_id = #{params.first.first.to_s.to_i}")
    unless @titles.blank?
      @titles.each do |title|
        @titles_options << "<option value='#{title.id}'>#{title.name}</option>"
      end
    end
    render :text => @titles_options << "</select>"
  end
  
end
