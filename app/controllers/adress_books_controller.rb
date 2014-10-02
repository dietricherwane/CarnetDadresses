class AdressBooksController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  # List persons and display create form
  def persons
    @adress_book = AdressBook.new
    init_adress_book("person_id")
  end
  
  # Create a person
  def create_person
    init_adress_book("person_id")
    
    @adress_book = AdressBook.new(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id))
    if @adress_book.save
      # Creates an entry in the logs
      LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      @adress_book = AdressBook.new
      flash.now[:success] = "Le Décideur a été correctement créé."
    else
      flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join      
    end
    render :persons
  end
  
  def search_person
    search(["firstname", "lastname", "company_name", "trading_identifier", "phone_number", "mobile_number", "email"], params[:terms], "person_id")
    
    render "persons"
  end
  
  def fetch_from_side_table(table, term)
    results = eval(table[0]).where("name ILIKE '%#{term}%'")
    return results.blank? ? "" : "#{table[1]} IN #{results.map{|t| t.id}.to_s.sub('[', '(').sub(']', ')')} OR "
  end
  
  def edit_person
    @adress_book = AdressBook.find_by_id(params[:id])
    init_adress_book("person_id")
    
    unless @adress_book
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end  
  end
  
  def update_person
    @adress_book = AdressBook.find_by_id(params[:id])
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      
      # Set hash for logs
      @new_adress_book = {}
      @old_adress_book = @adress_book.attributes.except("id", "created_at", "updated_at")
      params[:adress_book].each { |k,v| @new_adress_book.merge!("new_#{k}" => v) }

   
      @adress_book.update_attributes(params[:adress_book])
      if @adress_book.errors.full_messages.blank? 
        flash.now[:success] = "Le profil a été mis à jour."
        
        # Save log entry
        LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.person_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id)) 
      else
        flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      init_adress_book("person_id")   
      render :edit_person, id: @adress_book.id

    end    
  end
  
  def disable_person
    enable_disable_entry("désactiver", "désactivée", "person_id", false)
  end
  
  def enable_person
    enable_disable_entry("activer", "activée", "person_id", true)
  end
  
  # List companies and display create form
  def companies
    @adress_book = AdressBook.new
    init_adress_book("company_id")
  end
  
  # Create a company
  def create_company
    init_adress_book("company_id")
    
    @adress_book = AdressBook.new(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id))
    if @adress_book.save
      # Creates an entry in the logs
      LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "L'Entreprise a été correctement créée."
    else
      flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join      
    end
    render :companies
  end
  
  def search_company
    search(["company_name", "trading_identifier", "phone_number", "mobile_number", "email"], params[:terms], "company_id")
    
    render "companies"
  end
  
  def edit_company
    @adress_book = AdressBook.find_by_id(params[:id])
    init_adress_book("company_id")
    
    unless @adress_book
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end  
  end
  
  def update_company
    @adress_book = AdressBook.find_by_id(params[:id])
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      # Set hash for logs
      @new_adress_book = {}
      @old_adress_book = @adress_book.attributes.except("id", "created_at", "updated_at")
      params[:adress_book].each { |k,v| @new_adress_book.merge!("new_#{k}" => v) }
    
      @adress_book.update_attributes(params[:adress_book])
      if @adress_book.errors.full_messages.blank? 
        flash.now[:success] = "Le profil a été mis à jour." 
        # Save log entry
        LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id)) 
      else 
        flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      init_adress_book("company_id")   
      render :edit_company, id: @adress_book.id
    end    
  end 
  
  def disable_company
    enable_disable_entry("désactiver", "désactivée", "company_id", false)
  end
  
  def enable_company
    enable_disable_entry("activer", "activée", "company_id", true)
  end
  
  def enable_disable_entry(message1, message2, adress_book_type, status)
    @adress_book = AdressBook.find_by_id(params[:id])
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @adress_book.update_attributes(published: status)
      flash[:success] = "L'entrée a été #{message2}." 
               
      init_adress_book(adress_book_type)  
      
      redirect_to :back
    end   
  end
  
  #Set variables for the form
  def init_adress_book(entry)  
    @adress_books = AdressBook.where(profile_id: Profile.send(entry)).page(params[:page]).per(10)
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
    @sales_areas = SalesArea.where(published: [nil, true])
  end
  
  def create_adress_book_entry(entry, label)
    if @adress_book.save
      # Creates an entry in the logs
      LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.send(entry), update_type_id: UpdateType.create_type_id))
      flash.now[:success] = "#{label} a été correctement créé."
    else
      flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join      
    end
  end
  
  def search(fields, terms, adress_book_type)
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
    @sales_areas = SalesArea.where(published: [nil, true])
    @adress_book = AdressBook.new
    
    @tables = [["Sector", "sector_id"], ["SalesArea", "sales_area_id"], ["SocialStatus", "social_status_id"]]
    @fields = fields
    @terms = terms.strip.split
           
    # Executes a search function in application_controller to return results
    complex_search_function

    @adress_books = AdressBook.where(@sql + "#{@sql.blank? ? "" : " AND "}profile_id = #{Profile.send(adress_book_type)}")
    flash.now[:success] = "#{@adress_books.count} résultat#{@adress_books.count > 1 ? "s" : ""} de recherche."
    @adress_books = @adress_books.page(params[:page]).per(10)
  end
  
end
