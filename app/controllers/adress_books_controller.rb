class AdressBooksController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!

  layout :layout_used

  # List persons and display create form
  def persons
    @company = Company.new
    @holding = Holding.new
    @adress_book = AdressBook.new
    init_create_adress_book
  end

  # Create a person
  def create_person
    @adress_book = AdressBook.new(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id, sector_id: Sector.find_by_name("Privé").id, country_id: Country.find_by_name("Côte D'ivoire").id))
    if @adress_book.save
      # Creates an entry in the logs
      LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.person_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      #@adress_book = AdressBook.new
      flash.now[:success] = "Le Décideur a été correctement créé."
      redirect_to "/person/complete_profile/#{@adress_book.id}"
    else
      @company = Company.new
      @holding = Holding.new
      init_create_adress_book

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
    init_edit_adress_book

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

      init_edit_adress_book

      render :edit_person, id: @adress_book.id
    end
  end

  def disable_person
    enable_disable_entry("désactiver", "désactivée", "person_id", false, "persons")
  end

  def enable_person
    enable_disable_entry("activer", "activée", "person_id", true, "persons")
  end

  def enable_disable_entry(message1, message2, adress_book_type, status, return_method)
    @adress_book = AdressBook.find_by_id(params[:id])
    if @adress_book.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @adress_book.update_attributes(published: status)
      flash[:success] = "L'entrée a été #{message2}."

      init_adress_book

      #render send(return_method)
      redirect_to "/#{return_method}"
    end
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

  def init_create_adress_book
    init_adress_book

    @holdings = Holding.where(published: [nil, true])
    @social_statuses = SocialStatus.where(published: [nil, true])

  end

  def init_edit_adress_book
    init_adress_book

    @address_book_titles = AddressBookTitle.where("address_book_title_category_id = #{@adress_book.address_book_title.address_book_title_category_id}") rescue []
  end

  def init_adress_book
    @sales_areas = SalesArea.all
    @civilities = Civility.all
    @companies = Company.where(published: [nil, true])
    @marital_statuses = MaritalStatus.all
    @address_book_title_categories = AddressBookTitleCategory.all
    @adress_books = AdressBook.all.page(params[:page]).per(10)
  end

  def search(fields, terms, adress_book_type)
=begin
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
    @sales_areas = SalesArea.where(published: [nil, true])
    @adress_book = AdressBook.new
    @civilities = Civility.all
    @marital_statuses = MaritalStatus.all
    @countries = Country.all
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
=end
    @adress_book = AdressBook.new
    @company = Company.new
    @holding = Holding.new
    init_create_adress_book

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
      init_formation
      init_job_experience
      init_previous_job_experience
      init_adress_book_hobby
      init_complete_profile_combo_fields
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

    init_job_experience
    init_previous_job_experience
    init_adress_book_hobby
    init_complete_profile_combo_fields

    render :complete_profile
  end

  def edit_formation
    @formation = Formation.find_by_id(params[:id])
    @adress_book = @formation.adress_book
    @formations = @adress_book.formations.page(params[:page]).per(10)

    init_complete_profile_combo_fields
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

      init_complete_profile_combo_fields
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
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    init_formation
    init_previous_job_experience
    init_adress_book_hobby
    init_complete_profile_combo_fields

    render :complete_profile
  end

  def edit_experience
    @job_experience = JobExperience.find_by_id(params[:id])
    @adress_book = @job_experience.adress_book
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
    init_complete_profile_combo_fields
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
      @adress_book = AdressBook.find_by_id(params[:adress_book_id])
      @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
      init_complete_profile_combo_fields
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

  def create_previous_experience
    @previous_job_experience = PreviousJobExperience.new(params[:previous_job_experience].merge(user_id: current_user.id, adress_book_id: params[:adress_book_id]))
    if @previous_job_experience.save
      # Creates an entry in the logs
      #LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "L'expérience a été correctement créée."
      @previous_job_experience = PreviousJobExperience.new
    else
      flash.now[:error] = @previous_job_experience.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end
    @adress_book = AdressBook.find_by_id(params[:adress_book_id])
    @previous_job_experiences = @adress_book.previous_job_experiences.page(params[:page]).per(10)
    init_formation
    init_job_experience
    init_adress_book_hobby
    init_complete_profile_combo_fields

    render :complete_profile
  end

  def edit_previous_experience
    @previous_job_experience = PreviousJobExperience.find_by_id(params[:id])
    @adress_book = @previous_job_experience.adress_book
    @previous_job_experiences = @adress_book.previous_job_experiences.page(params[:page]).per(10)
    @memberships = Membership.all
    unless @previous_job_experience
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update_previous_experience
    @previous_job_experience = PreviousJobExperience.find_by_id(params[:id])
    if @previous_job_experience.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @previous_job_experience.update_attributes(params[:previous_job_experience])
      if @previous_job_experience.errors.full_messages.blank?
        flash.now[:success] = "L'expérience professionnelle a été mise à jour."
        # Save log entry
        #LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id))
      else
        flash.now[:error] = @previous_job_experience.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      @adress_book = @previous_job_experience.adress_book
      @previous_job_experiences = @adress_book.previous_job_experiences.page(params[:page]).per(10)
      @memberships = Membership.all
    end

    render :edit_previous_experience
  end

  def disable_previous_experience
    enable_disable_previous_experience("désactivée", false)
  end

  def enable_previous_experience
    enable_disable_previous_experience("activée", true)
  end

  def enable_disable_previous_experience(message, status)
    @previous_job_experience = PreviousJobExperience.find_by_id(params[:id])
    if @previous_job_experience.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @previous_job_experience.update_attributes(published: status)
      flash[:success] = "L'expérience professionnelle a été #{message}."

      redirect_to complete_person_profile_path(@previous_job_experience.adress_book.id)
    end
  end

  def create_hobby
    @adress_book_hobby = AdressBookHobby.new(params[:adress_book_hobby].merge(user_id: current_user.id, adress_book_id: params[:adress_book_id]))
    if @adress_book_hobby.save
      # Creates an entry in the logs
      #LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, profile_id: Profile.company_id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "Le hobby a été correctement créé."
      @adress_book_hobby = AdressBookHobby.new
    else
      flash.now[:error] = @adress_book_hobby.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end
    @adress_book = AdressBook.find_by_id(params[:adress_book_id])
    @adress_book_hobbies = @adress_book.adress_book_hobbies.page(params[:page]).per(10)
    init_formation
    init_job_experience
    init_previous_job_experience
    init_complete_profile_combo_fields

    render :complete_profile
  end

  def edit_hobby
    @adress_book_hobby = AdressBookHobby.find_by_id(params[:id])
    @adress_book = @adress_book_hobby.adress_book
    @adress_book_hobbies = @adress_book.adress_book_hobbies.page(params[:page]).per(10)
    @hobbies = Hobby.all
    unless @adress_book_hobby
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update_hobby
    @adress_book_hobby = AdressBookHobby.find_by_id(params[:id])
    if @adress_book_hobby.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @adress_book_hobby.update_attributes(params[:adress_book_hobby])
      if @adress_book_hobby.errors.full_messages.blank?
        flash.now[:success] = "Le hobby a été mise à jour."
        # Save log entry
        #LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id))
      else
        flash.now[:error] = @adress_book_hobby.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      @adress_book = AdressBook.find_by_id(params[:adress_book_id])
      @adress_book_hobbies = @adress_book.adress_book_hobbies.page(params[:page]).per(10)
      @hobbies = Hobby.all
    end

    render :edit_hobby
  end

  def disable_hobby
    enable_disable_hobby("désactivé", false)
  end

  def enable_hobby
    enable_disable_hobby("activé", true)
  end

  def enable_disable_hobby(message, status)
    @adress_book_hobby = AdressBookHobby.find_by_id(params[:id])
    if @adress_book_hobby.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @adress_book_hobby.update_attributes(published: status)
      flash[:success] = "Le hobby a été #{message}."

      redirect_to complete_person_profile_path(@adress_book_hobby.adress_book.id)
    end
  end

  def init_formation
    @formation = Formation.new
    @formations = @adress_book.formations.page(params[:page]).per(10)
  end

  def init_job_experience
    @job_experience = JobExperience.new
    @job_experiences = @adress_book.job_experiences.page(params[:page]).per(10)
  end

  def init_previous_job_experience
    @previous_job_experience = PreviousJobExperience.new
    @previous_job_experiences = @adress_book.previous_job_experiences.page(params[:page]).per(10)
  end

  def init_adress_book_hobby
    @adress_book_hobby = AdressBookHobby.new
    @adress_book_hobbies = @adress_book.adress_book_hobbies.page(params[:page]).per(10)
  end

  def init_complete_profile_combo_fields
    @memberships = Membership.all
    @hiring_statuses = HiringStatus.all
    @hiring_types = HiringType.all
    @hobbies = Hobby.all
  end

end
