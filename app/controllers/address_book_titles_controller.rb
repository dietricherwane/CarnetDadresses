class AddressBookTitlesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

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

  def api_show
    address_book_title = AddressBookTitle.find_by_id(params[:id])
    address_book_title_category = address_book_title.address_book_title_category rescue nil
    address_book_title = address_book_title.as_json

    my_hash = api_render_object(address_book_title, {category_name: (address_book_title_category.name rescue "")}, ["published", "updated_at", "created_at", "id", "address_book_title_category_id"])

    render json: my_hash
  end

end
