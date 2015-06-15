class AdressBooksController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_find_per_first_letter, :api_persons_list, :api_person, :api_previous_jobs, :api_hobbies, :api_formations, :api_job, :job_categories]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout "back_office"

  # List persons and display create form
  def persons
    @company = Company.new
    @holding = Holding.new
    @adress_book = AdressBook.new
    init_create_adress_book
  end

  # Create a person
  def create_person
    if current_user.admin?
      params[:adress_book].merge!(published: false)
    end

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
    init_create_adress_book
    search(["firstname", "lastname", "phone_number", "email"], params[:terms])

    render "persons"
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
    @countries = Country.all
    @sales_areas = SalesArea.all
    @civilities = Civility.all
    @companies = Company.where(published: [nil, true])
    @marital_statuses = MaritalStatus.all
    @address_book_title_categories = AddressBookTitleCategory.all
    @adress_books = AdressBook.all.page(params[:page]).per(10)
  end

  def search(fields, terms)
    @adress_book = AdressBook.new
    @company = Company.new
    @holding = Holding.new
    init_create_adress_book

    @tables = [["Sector", "sector_id"]]
    @fields = fields
    @terms = terms.strip.split

    # Executes a search function in application_controller to return results
    complex_search_function

    @adress_books = AdressBook.where(@sql).order("firstname ASC")

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

  ################################API###########################################

  def api_person
    adress_book = AdressBook.find_by_id(params[:id])
    my_hash = api_render_merged_object(adress_book, api_fields_to_except, AdressBooksController, "api_additional_fields_to_merge")

    render json: my_hash
  end

  def api_persons_list
    adress_books = AdressBook.where("published IS NOT FALSE").as_json
    my_hash = api_render_several_merged_objects(adress_books, api_fields_to_except, AdressBooksController, "api_additional_fields_to_merge")

    render json: my_hash
  end

  def api_find_per_first_letter
    adress_books = AdressBook.where("firstname ILIKE '#{params[:letter]}%' AND published IS NOT FALSE").as_json
    my_hash = api_render_several_merged_objects(adress_books, api_fields_to_except, AdressBooksController, "api_additional_fields_to_merge")

    render json: my_hash
  end

  def api_render(rendered_object)
    render json: rendered_object
  end

  def api_hobbies
    adress_book = AdressBook.find_by_id(params[:id])
    if adress_book
      hobbies = adress_book.hobbies.where(published: [true, nil]).as_json rescue nil
      my_hash = api_render_several_objects(hobbies, {}, ["published", "id", "created_at", "updated_at"])
    else
      my_hash = "{"'"data"'":[]}"
    end

    render json: my_hash
  end

  def api_formations
    adress_book = AdressBook.find_by_id(params[:id])
    if adress_book
      formations = adress_book.formations.where(published: [true, nil]).as_json rescue nil
      my_hash = api_render_several_objects(formations, {}, ["published", "id", "created_at", "updated_at", "user_id", "adress_book_id"])
    else
      my_hash = "{"'"data"'":[]}"
    end

    render json: my_hash
  end

  def api_job
    adress_book = AdressBook.find_by_id(params[:id])
    if adress_book
      jobs = adress_book.job_experiences.where(published: [true, nil]).as_json rescue nil
      my_hash = api_render_several_objects(jobs, {}, ["published", "id", "created_at", "updated_at", "user_id", "adress_book_id"])
    else
      my_hash = "{"'"data"'":[]}"
    end

    render json: my_hash
  end

  def api_previous_jobs
    adress_book = AdressBook.find_by_id(params[:id])
    if adress_book
      previous_jobs = adress_book.previous_job_experiences.where(published: [true, nil]).as_json rescue nil
      my_hash = api_render_several_objects(previous_jobs, {}, ["published", "id", "created_at", "updated_at", "user_id", "adress_book_id"])
    else
      my_hash = "{"'"data"'":[]}"
    end

    render json: my_hash
  end

  def job_categories
    jobs = AdressBook.unscoped.select("DISTINCT job_role")#.map{|j|  %Q/"name": "#{j.job_role}"/ + "}"}
    if !jobs.blank?
      my_container = ""
      jobs.each do |job|
        my_container << ("{" + %Q/"name":"#{job.job_role}"/ + "},")
      end
      my_hash = %Q/{"data":[#{my_container.chop}]}/
    else
      my_hash = "{"'"data"'":[]}"
    end

    render json: my_hash
  end

  def api_additional_fields_to_merge(adress_book)
    return additional_fields_to_merge(adress_book)
  end

  def self.api_additional_fields_to_merge(adress_book)
    return additional_fields_to_merge(adress_book)
  end

  def self.additional_fields_to_merge(adress_book)
    return {avatar: ("http://41.189.40.193:6556#{AdressBook.find_by_id(adress_book["id"]).avatar.url(:thumb)}" rescue nil), civility: (Civility.find_by_id(adress_book["civility_id"]).name rescue nil), marital_status: (MaritalStatus.find_by_id(adress_book["marital_status_id"]).name rescue nil), title: (AdressBookTitle.find_by_id(adress_book["adress_book_title_id"]).name rescue nil), company_name: (Company.find_by_id(adress_book["company_id"]).name rescue nil)}
  end

  def api_fields_to_except
    return ["profile_id", "created_by", "sector_id", "country_id", "employment_company", "avatar_file_name", "avatar_content_type", "avatar_file_size", "avatar_updated_at", "sub_sales_area_id"]
  end

  def load_file

  end

  def save_loaded_file
    inserted = false
    @address_books_file = params[:address_books_file]
    validate_address_books_file

    unless @error
      @spreadsheet = Spreadsheet.open(@address_books_file.path).worksheet(0)
      @spreadsheet.each do |row|
        address_book_title_id = AddressBookTitle.find_by_name(row[0]).id rescue nil
        civility_id = Civility.find_by_name(row[1]).id rescue nil
        firstname = row[2]
        lastname = row[3]
        birthdate = Date.parse(row[4]) rescue nil
        marital_status_id = MaritalStatus.find_by_name(row[5]).id rescue nil
        childrens = row[6]
        company_id = Company.find_by_name(row[7]).id rescue nil
        job_role = row[8]
        city = row[9]
        geographical_address = row[10]
        postal_address = row[11]
        phone_number = row[12]
        email = row[13]
        comment = row[14]
        #hobby_id = Hobby.find_by_name(row[15]).id rescue nil

        @address_book = AdressBook.new(address_book_title_id: address_book_title_id, civility_id: civility_id, firstname: firstname, lastname: lastname, birthdate: birthdate, marital_status_id: marital_status_id, childrens: childrens, company_id: company_id, job_role: job_role, city: city, geographical_address: geographical_address, postal_address: postal_address, phone_number: phone_number, email: email, comment: comment, created_by: current_user.id, profile_id: Profile.person_id, sector_id: Sector.find_by_name("Privé").id, country_id: Country.find_by_name("Côte D'ivoire").id)
        #render text: @address_book.inspect
        if @address_book.save
          inserted = true
          #@address_book.adress_book_hobbies.create(hobby_id: hobby_id, user_id: current_user.id)
          #address_book_hobby.save
        end
      end
    end

    inserted == true ? flash.now[:success] = "Les données ont été insérées." : flash.now[:error] = @address_book.errors.full_messages.map{|msg| "<p>#{msg}</p>"}.join#"Aucune donnée n'a été insérée."

    render :load_file
  end

  # Make sure the user uploads an xls or xlsx file
  def validate_address_books_file
    if @address_books_file.blank? || (@address_books_file.content_type != "application/vnd.ms-excel" && @address_books_file.content_type != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
      flash.now[:error] = "Veuillez choisir un fichier Excel contenant une liste d'entreprises."
      @error = true
    end
  end

  def get_holding_id
    @holding_id = Holding.find_by_name(@holding_name).id rescue nil
  end

end
