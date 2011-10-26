class ContsController < ApplicationController
  # GET /conts
  # GET /conts.json
  def index
    @conts = Cont.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conts }
    end
  end

  # GET /conts/1
  # GET /conts/1.json
  def show
    @cont = Cont.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cont }
    end
  end

  # GET /conts/new
  # GET /conts/new.json
  def new
    @cont = Cont.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cont }
    end
  end

  # GET /conts/1/edit
  def edit
    @cont = Cont.find(params[:id])
  end

  # POST /conts
  # POST /conts.json
  def create
    @cont = Cont.new(params[:cont])

    respond_to do |format|
      if @cont.save
        format.html { redirect_to @cont, notice: 'Cont was successfully created.' }
        format.json { render json: @cont, status: :created, location: @cont }
      else
        format.html { render action: "new" }
        format.json { render json: @cont.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conts/1
  # PUT /conts/1.json
  def update
    @cont = Cont.find(params[:id])

    respond_to do |format|
      if @cont.update_attributes(params[:cont])
        format.html { redirect_to @cont, notice: 'Cont was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cont.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conts/1
  # DELETE /conts/1.json
  def destroy
    @cont = Cont.find(params[:id])
    @cont.destroy

    respond_to do |format|
      format.html { redirect_to conts_url }
      format.json { head :ok }
    end
  end
  
  # if the link already exist, return the content
  # else add a new
  def g
    link = params[:link]
    @cont = Cont.where(:link => link)
	@cont = @cont.first
	if @cont.nil?
	  p 'extracting .............'
	  error_type = 0 #success
	  content = ''
	  html = ''
	  error_msg = ''
	  begin
        html = open(link).read
	  rescue => e
	    error_type = 1 #HTML error
		error_msg = e.backtrace
	  end
	  
	  if error_type == 0
	    begin  
          doc = Readability::Document.new(source, :debug=>true)#; p doc.html.encoding
          encoding = doc.html.encoding
          encoding = "GBK" if encoding.nil?
          content = Iconv.iconv('utf-8', encoding, doc.content).join
        rescue
		  error_type = 2 # READABILITY ERROR
		  error_msg = e.backtrace
		end
	  end

      @cont = Cont.new(
	    :link => link,
	    :html => html,
	    :content => content,
	    :error_type => error_type,
	    :error_msg => error_msg
	  )
      @cont.save
	end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cach }
    end
  end
end
