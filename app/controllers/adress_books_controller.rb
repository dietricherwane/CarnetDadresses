class AdressBooksController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  # List persons and display create form
  def persons
    @company = Company.new
    @holding = Holding.new
    @holdings = Holding.where(published: [nil, true])
    @companies = Company.all
    
    @adress_book = AdressBook.new
    @civilities = Civility.all
    @countries = Country.all
    @address_book_title_categories = AddressBookTitleCategory.all
    @marital_statuses = MaritalStatus.all
    init_adress_book("person_id")
  end
  
  # Create a person
  def create_person
    init_adress_book("person_id")
    @company = Company.new
    @companies = Company.all
    @holdings = Holding.where(published: [nil, true])
    
    @adress_book = AdressBook.new(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id, sector_id: Sector.find_by_name("Privé").id, country_id: Country.find_by_name("Côte D'ivoire").id))
    if @adress_book.save
      # Creates an entry in the logs
      LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      #@adress_book = AdressBook.new
      flash.now[:success] = "Le Décideur a été correctement créé."
      redirect_to "/person/complete_profile/#{@adress_book.id}"  
    else
      @civilities = Civility.all
      @marital_statuses = MaritalStatus.all
      @address_book_title_categories = AddressBookTitleCategory.all
      @countries = Country.all
      flash.now[:error] = @adress_book.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join      
      render :persons
    end
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
    @companies = Company.all
    @civilities = Civility.all
    @marital_statuses = MaritalStatus.all
    @address_book_title_categories = AddressBookTitleCategory.all
    @address_book_titles = AddressBookTitle.where("address_book_title_category_id = #{@adress_book.address_book_title.address_book_title_category_id}") rescue []
    @countries = Country.all
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
      @civilities = Civility.all
      @marital_statuses = MaritalStatus.all
      @companies = Company.all
      @address_book_title_categories = AddressBookTitleCategory.all
      @address_book_titles = AddressBookTitle.where("address_book_title_category_id = #{@adress_book.address_book_title.address_book_title_category_id}") rescue []
      @countries = Country.all
      
      render :edit_person, id: @adress_book.id
    end    
  end
  
  def disable_person
    enable_disable_entry("désactiver", "désactivée", "person_id", false, "persons")
  end
  
  def enable_person
    enable_disable_entry("activer", "activée", "person_id", true, "persons")
  end
  
  # List companies and display create form
  def companies
    @adress_book = AdressBook.new
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
    init_adress_book("company_id")
  end
  
  # Create a company
  def create_company
    init_adress_book("company_id")
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
    
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
  
  def js_create_company
    @adress_book = AdressBook.new(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id))
    respond_to do |format|
      if @adress_book.save
        format.js   { render action: 'persons', status: :created, location: @adress_book }
      else
        format.js   { render json: @adress_book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def search_company
    search(["company_name", "trading_identifier", "phone_number", "mobile_number", "email"], params[:terms], "company_id")
    
    render "companies"
  end
  
  def edit_company
    @adress_book = AdressBook.find_by_id(params[:id])
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
    init_adress_book("company_id")
    
    unless @adress_book
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end  
  end
  
  def update_company
    @adress_book = AdressBook.find_by_id(params[:id])
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
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
    enable_disable_entry("désactiver", "désactivée", "company_id", false, "companies")
  end
  
  def enable_company
    enable_disable_entry("activer", "activée", "company_id", true, "companies")
  end
  
  def enable_disable_entry(message1, message2, adress_book_type, status, return_method)
    @adress_book = AdressBook.find_by_id(params[:id])
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @adress_book.update_attributes(published: status)
      flash[:success] = "L'entrée a été #{message2}." 
               
      init_adress_book(adress_book_type)  
      
      #render send(return_method)
      redirect_to "/#{return_method}"
    end   
  end
  
  #Set variables for the form
  def init_adress_book(entry)  
    @adress_books = AdressBook.where(profile_id: Profile.send(entry)).page(params[:page]).per(10)
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
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
    @civilities = Civility.all
    @marital_statuses = MaritalStatus.all
    @countries = Country.all
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
    
    @tables = [["Sector", "sector_id"], ["SalesArea", "sales_area_id"], ["SocialStatus", "social_status_id"]]
    @fields = fields
    @terms = terms.strip.split
           
    # Executes a search function in application_controller to return results
    complex_search_function

    @adress_books = AdressBook.where(@sql + "#{@sql.blank? ? "" : " AND "}profile_id = #{Profile.send(adress_book_type)}")
    flash.now[:success] = "#{@adress_books.count} résultat#{@adress_books.count > 1 ? "s" : ""} de recherche."
    @adress_books = @adress_books.page(params[:page]).per(10)
  end
  
  def complete_profile
    @adress_book = AdressBook.find_by_id(params[:id])
        
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else 
      @formations = @adress_book.formations.page(params[:page]).per(10) 
      @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10) 
      @formation = Formation.new
      @job_experience = JobExperience.new
      @memberships = Membership.all
      @hiring_statuses = HiringStatus.all
      @hiring_types = HiringType.all
    end
  end
  
  def create_formation
    @formation = Formation.new(params[:formation].merge(user_id: current_user.id, adress_book_id: params[:adress_book_id]))
    if @formation.save
      # Creates an entry in the logs
      #LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "La formation a été correctement créée."     
      @formation = Formation.new      
    else
      flash.now[:error] = @formation.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join           
    end   
    @adress_book = AdressBook.find_by_id(params[:adress_book_id])
    @formations = @adress_book.formations.page(params[:page]).per(10)
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    @memberships = Membership.all
    @hiring_statuses = HiringStatus.all
    @hiring_types = HiringType.all
    @job_experience = JobExperience.new
    
    render :complete_profile
  end
  
  def edit_formation
    @formation = Formation.find_by_id(params[:id])
    @adress_book = @formation.adress_book
    @formations = @adress_book.formations.page(params[:page]).per(10)
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    @memberships = Membership.all
    @hiring_statuses = HiringStatus.all
    @hiring_types = HiringType.all
    @job_experience = JobExperience.new
    unless @formation
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
  
  def update_formation
    @formation = Formation.find_by_id(params[:id])
    if @formation.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @formation.update_attributes(params[:formation])
      if @formation.errors.full_messages.blank? 
        flash.now[:success] = "La formation a été mise à jour." 
        # Save log entry
        #LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id)) 
      else 
        flash.now[:error] = @formation.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      @adress_book = @formation.adress_book
      @formations = @adress_book.formations.page(params[:page]).per(10)
      @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
      @memberships = Membership.all
      @hiring_statuses = HiringStatus.all
      @hiring_types = HiringType.all
    end
    
    render :edit_formation 
  end
  
  def disable_formation
    enable_disable_formation("désactivée", false)
  end
  
  def enable_formation
    enable_disable_formation("activée", true)
  end
  
  def enable_disable_formation(message, status)
    @formation = Formation.find_by_id(params[:id])
    if @formation.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @formation.update_attributes(published: status)
      flash[:success] = "L'entrée a été #{message}." 
      
      redirect_to complete_person_profile_path(@formation.adress_book.id)
    end   
  end
  
  def create_experience
    @job_experience = JobExperience.new(params[:job_experience].merge(user_id: current_user.id, adress_book_id: params[:adress_book_id]))
    if @job_experience.save
      # Creates an entry in the logs
      #LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "L'expérience a été correctement créée."     
      @job_experience = JobExperience.new      
    else
      flash.now[:error] = @job_experience.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join           
    end   
    @adress_book = AdressBook.find_by_id(params[:adress_book_id])
    @formations = @adress_book.formations.page(params[:page]).per(10)
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    @memberships = Membership.all
    @hiring_statuses = HiringStatus.all
    @hiring_types = HiringType.all
    @formation = Formation.new 
    
    render :complete_profile
  end
  
  def edit_experience
    @job_experience = JobExperience.find_by_id(params[:id])
    @adress_book = @job_experience.adress_book
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    @memberships = Membership.all
    @hiring_statuses = HiringStatus.all
    @hiring_types = HiringType.all
    unless @job_experience
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
  
  def update_experience
    @job_experience = JobExperience.find_by_id(params[:id])
    if @job_experience.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @job_experience.update_attributes(params[:job_experience])
      if @job_experience.errors.full_messages.blank? 
        flash.now[:success] = "L'expérience professionnelle a été mise à jour." 
        # Save log entry
        #LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id)) 
      else 
        flash.now[:error] = @job_experience.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      @adress_book = @job_experience.adress_book
      @formations = @adress_book.formations.page(params[:page]).per(10)
      @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
      @memberships = Membership.all
      @hiring_statuses = HiringStatus.all
      @hiring_types = HiringType.all
    end
    
    render :edit_experience 
  end
  
  def disable_experience
    enable_disable_experience("désactivée", false)
  end
  
  def enable_experience
    enable_disable_experience("activée", true)
  end
  
  def enable_disable_experience(message, status)
    @job_experience = JobExperience.find_by_id(params[:id])
    if @job_experience.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else     
      @job_experience.update_attributes(published: status)
      flash[:success] = "L'expérience professionnelle a été #{message}." 
      
      redirect_to complete_person_profile_path(@job_experience.adress_book.id)
    end   
  end
  
end
