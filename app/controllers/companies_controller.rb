class CompaniesController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel ]
  @@api_functions = [:api_show, :api_list]

  before_filter :sign_out_disabled_users, except: @@api_functions
  prepend_before_filter :authenticate_user!, except: @@api_functions

  layout :layout_used

  def companies
    @company = Company.new
    init_company
  end

  def create
    init_company

    @company = Company.new(params[:company].merge(created_by: current_user.id, sector_id: Sector.find_by_name("Privé").id, country_id: Country.find_by_name("Côte D'ivoire").id))
    if @company.save
      @company = Company.new
      # Creates an entry in the logs
      #LastUpdate.create(params[:adress_book].merge(created_by: current_user.id, update_type_id: UpdateType.create_type_id, user_id: @adress_book.id))
      flash.now[:success] = "L'Entreprise a été correctement créée."
    else
      flash.now[:error] = @company.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
    end
    render :companies
  end

  def edit
    @company = Company.find_by_id(params[:id])
    @sub_sales_areas = SubSalesArea.where("sales_area_id = #{@adress_book.sub_sales_area.sales_area_id}") rescue []
    init_company

    unless @company
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def update
    @company = Company.find_by_id(params[:id])

    if @company.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      # Set hash for logs
      @new_company = {}
      @old_company = @company.attributes.except("id", "created_at", "updated_at")
      params[:company].each { |k,v| @new_company.merge!("new_#{k}" => v) }

      @company.update_attributes(params[:company])
      if @company.errors.full_messages.blank?
        flash.now[:success] = "Le profil a été mis à jour."
        # Save log entry
        #LastUpdate.create(@old_adress_book.merge(@new_adress_book).merge(new_created_by: current_user.id, new_profile_id: Profile.company_id, update_type_id: UpdateType.update_type_id, user_id: @adress_book.id))
      else
        flash.now[:error] = @company.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end
      init_company
      @sub_sales_areas = SubSalesArea.where("sales_area_id = #{@adress_book.sub_sales_area.sales_area_id}") rescue []

      render :edit, id: @company.id
    end
  end

  def disable_company
    enable_disable_company("désactivée", false)
  end

  def enable_company
    enable_disable_company("activée", true)
  end

  def enable_disable_company(message, status)
    @company = Company.find_by_id(params[:id])
    if @company.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @company.update_attributes(published: status)
      flash[:success] = "L'entrée a été #{message}."

      redirect_to companies_path
    end
  end

  def init_company
    @holding = Holding.new
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all
    @companies = Company.all.page(params[:page]).per(10)
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
    @sales_areas = SalesArea.all
  end

  def js_create
    @company = Company.new(params[:company].merge(created_by: current_user.id, sector_id: Sector.find_by_name("Privé").id, country_id: Country.find_by_name("Côte D'ivoire").id, sales_area_id: 1))
    respond_to do |format|
      if @company.save
        format.js   {
          render text: "ok", status: 200
        }
      else
        format.js   { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_companies
    @companies_options = "<select id = 'adress_book_company_id' class = 'form-control' name = 'adress_book[company_id]'><option>-Veuillez choisir une entreprise-</option>"
    @companies = Company.where(validated_by: [nil, true], published: [nil, true])
    unless @companies.blank?
      @companies.each do |company|
        @companies_options << "<option value='#{company.id}'>#{company.name}</option>"
      end
    end
    render :text => @companies_options << "</select>"
  end

  def search_company
    search(["name", "trading_identifier", "phone_number", "email"], params[:terms], "company_id")

    render "companies"
  end

  def search(fields, terms, adress_book_type)
    @sectors = Sector.where(published: [true, nil])
    @social_statuses = SocialStatus.where(published: [nil, true])
    @sales_areas = SalesArea.where(published: [nil, true])
    @company = Company.new
    @countries = Country.all
    @holdings = Holding.where(published: [nil, true])
    @countries = Country.all

    @tables = [["Sector", "sector_id"], ["SalesArea", "sales_area_id"], ["SocialStatus", "social_status_id"]]
    @fields = fields
    @terms = terms.strip.split

    # Executes a search function in application_controller to return results
    complex_search_function

    @companies = Company.where(@sql)
    flash.now[:success] = "#{@companies.count} résultat#{@companies.count > 1 ? "s" : ""} de recherche."
    @companies = @companies.page(params[:page]).per(10)
  end

  def api_show
    company = Company.find_by_id(params[:id]).as_json

    if company
      company = "[" << company.merge(logo: "#{Rails.root}#{Company.find_by_id(company["id"]).logo.url(:thumb)}").except!(*["published", "updated_at", "created_at", "id", "created_by", "validated_by", "sector_id"]).to_json << "]"
    else
      company = []
    end

    render json: company
  end

  def api_list
    companies = Company.where("published IS NOT FALSE").as_json
    my_hash = "["
    companies.each do |company|
      my_hash << company.merge(logo: "#{Rails.root}#{Company.find_by_id(company["id"]).logo.url(:thumb)}").except!(*["id", "published", "created_at", "sector_id", "created_by", "validated_by", "updated_at"]).to_json << ","
    end
    my_hash = my_hash[0..(my_hash.length - 2)]
    my_hash << "]"

    render json: my_hash
  end
end
