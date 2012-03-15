require 'cgi'
require 'open-uri'
require 'readability.rb'
#require 'iconv'

class ContsController < ApplicationController
  # GET /conts
  # GET /conts.json
  def index
    #@conts = Cont.all
	  @conts = Cont.paginate(:page => params[:page])

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
  
  #==================== processing start =================>
  def get_charset(text)
    charset_str = 'charset='
    ind = text.index(charset_str); p "find charset=" + ind.to_s
    if ind.nil?; return 'iso-8859-1'; end
    start = ind + charset_str.length#; p start.to_s
    ind2 = text.index('"', start)#; p ind2.to_s
    if ind2 == start #start with "
      ind3 = text.index('"', start+1);
      return text[(ind2+1)...ind3]
    else
      return text[start...ind2]
    end
  end

  def uncompress(string, encoding)
      case encoding
        when 'gzip'
          i=Zlib::GzipReader.new(StringIO.new(string))
          content=i.read
        when 'deflate'
          i=Zlib::Inflate.new
          content=i.inflate(string)
        else
          raise "Unknown encoding - #{encoding}"
      end
  end

  def trim_str(str); str.strip! || str; end

  def trim_title(raw_title)
    ind = raw_title.index(/[_-]/)
    ind.nil? ? raw_title : trim_str(raw_title[0...ind])
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
	  title = ''
	  #st = Time.now
	  begin
        a = open(link); p "header charset: #{a.charset}"
        text = a.read; p "text encoding: #{text.encoding.to_s}"
	    #p "get raw html time: #{Time.now - st}"
		enc = a.meta['content-encoding']
		if enc == 'gzip' || enc == 'inflate'
		  text = uncompress(text, enc)
          cs = get_charset(text); p "ziped charset: #{cs}"
		  text = text.force_encoding(cs).encode('UTF-8')
          text = text.sub(cs, 'UTF-8')
		end
        cs = get_charset(text); p "charset: #{cs}"
		html = text
		if "iso-8859-1".casecmp(cs) == 0 || "utf-8".casecmp(text.encoding.to_s) !=0
		  if "utf-8".casecmp(cs) != 0 && "utf-8".casecmp(text.encoding.to_s) !=0
		    p 'wrong charset, change'
		    html = text.force_encoding('GBK').encode('UTF-8')
		  end
		end
		html = html.force_encoding('utf-8')
        html = html.sub(cs, 'UTF-8')
	  rescue => e
	    error_type = 1 #HTML error
		error_msg = e.message.to_s
		p e.message
		p e.backtrace
	  end
	  #p "get html time: #{Time.now - st}"

      st = Time.now	  
	  if error_type == 0
	    begin  
#          doc = Readability::Document.new(html, :debug=>true)
          doc = Readability::Document.new(html)
          content = doc.content
		  title = trim_title(doc.html.title)
        rescue => e
		  error_type = 2 # READABILITY ERROR
		  error_msg = e.message.to_s
		  p e.message
		  p e.backtrace
		end
	  end
	  p "get readability time: #{Time.now - st}"

      @cont = Cont.new(
	    :link => link,
	    :html => '', #html,
	    :content => content,
		:title => title,
	    :error_type => error_type,
	    :error_msg => error_msg
	  )
      @cont.save
	end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cont }
    end
  end
end
