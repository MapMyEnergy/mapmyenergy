class HomesController < ApplicationController
  def dashboard
  end

  # GET /homes
  # GET /homes.json
  def index
    homes = Home.all

    a = Array.new
    
    properties = Rails.cache.fetch("cached_array", :expires_in => 4.hours) do
      homes.each do |home|
        z = home.zpid
        p = Rubillow::HomeValuation.zestimate({ :zpid => z })
        j = { :address => "#{p.address[:street]}, #{p.address[:city]}, #{p.address[:state]}", 
              :zpid => z, :lat => p.address[:latitude], :lng => p.address[:longitude], :zest => p.price, :rating => home.hers_rating } rescue {}
        a.push j
      end
      a
    end
    @properties = properties.to_json
  end

  def landing
    @body_classes = 'landing'
  end

  # GET /homes/1
  # GET /homes/1.json
  def show
    @home = Home.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @home }
    end
  end

  # GET /homes/new
  # GET /homes/new.json
  def new
    @home = Home.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @home }
    end
  end

  # GET /homes/1/edit
  def edit
    @home = Home.find(params[:id])
  end

  # POST /homes
  # POST /homes.json
  def create
    @home = Home.new(params[:home])

    respond_to do |format|
      if @home.save
        format.html { redirect_to @home, notice: 'Home was successfully created.' }
        format.json { render json: @home, status: :created, location: @home }
      else
        format.html { render action: "new" }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /homes/1
  # PUT /homes/1.json
  def update
    @home = Home.find(params[:id])

    respond_to do |format|
      if @home.update_attributes(params[:home])
        format.html { redirect_to @home, notice: 'Home was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    @home = Home.find(params[:id])
    @home.destroy

    respond_to do |format|
      format.html { redirect_to homes_url }
      format.json { head :no_content }
    end
  end
end
