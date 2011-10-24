class CachesController < ApplicationController
  # GET /caches
  # GET /caches.json
  def index
    @caches = Cache.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @caches }
    end
  end

  # GET /caches/1
  # GET /caches/1.json
  def show
    @cach = Cache.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cach }
    end
  end

  # GET /caches/new
  # GET /caches/new.json
  def new
    @cach = Cache.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cach }
    end
  end

  # GET /caches/1/edit
  def edit
    @cach = Cache.find(params[:id])
  end

  # POST /caches
  # POST /caches.json
  def create
    @cach = Cache.new(params[:cach])

    respond_to do |format|
      if @cach.save
        format.html { redirect_to @cach, notice: 'Cache was successfully created.' }
        format.json { render json: @cach, status: :created, location: @cach }
      else
        format.html { render action: "new" }
        format.json { render json: @cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /caches/1
  # PUT /caches/1.json
  def update
    @cach = Cache.find(params[:id])

    respond_to do |format|
      if @cach.update_attributes(params[:cach])
        format.html { redirect_to @cach, notice: 'Cache was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cach.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /caches/1
  # DELETE /caches/1.json
  def destroy
    @cach = Cache.find(params[:id])
    @cach.destroy

    respond_to do |format|
      format.html { redirect_to caches_url }
      format.json { head :ok }
    end
  end
end
