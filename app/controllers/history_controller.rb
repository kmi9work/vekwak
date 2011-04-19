class HistoryController < ApplicationController
  skip_before_filter :layout_work
  before_filter :logged_in?, :except => ["huser_login", "new", "register", "create"]
  layout false
  def logged_in?
    @huser = session[:huser] ? Huser.find(session[:huser]) : nil
    if @huser
      return true 
    elsif @student 
      @huser = Huser.where(:login => @student.login)[0] || 
               Huser.create(:login => @student.login, :name => "#{@student.name} #{@student.second_name[0].upcase}. #{@student.last_name[0].upcase}.")
      session[:huser] = @huser.id
      return true
    else
      redirect_to :new
    end
  end
    
  def huser_login
    if @huser = Huser.where(:login => params[:login], :password => params[:password])[0]
      session[:huser] = @huser.id 
      redirect_to :history
    else
      redirect_to :new
    end
  end
  
  def huser_logout
    if @huser or session[:huser]
      @huser = nil
      session[:huser] = nil
    end
    redirect_to :history
  end
  
  
  def new
  end
  
  def register
    @huser = Huser.new
  end
  
  def create
    puts params.inspect
    if params[:password] == params[:password_confirmation]
      @huser = Huser.new(params[:huser])
      @huser.uploaded = 0
      if @huser.save
        session[:huser] = @huser.id
        redirect_to :action => :index
      else
        render :register
      end
    else
      render :register
    end  
  end
  def huser_fadd
    p params[:fadd].readlines
    puts "n\n\n\n\n\n\n\n"
  end
  
  protected
  
  def parse_file(options, file)
    options, fnames = {}, []
    i = 0

    fmd5 = File.open("#{@user}.md5", "a+")
    
    if options[:a]
      adiumfile = File.open(options[:a][0])
      unless check_file fmd5, adiumfile
        puts "File repeated."
      end
      logs = parseAdium(adiumfile.readlines)
    end

    if options[:da]
      lines = read_all_in_dir(options[:da][0], fmd5)
      logs = parseAdium(lines)
    end

    if options[:q2005]
      qipfile = File.open(options[:q2005][0])
      unless check_file fmd5, qipfile
        puts "File repeated."
      end
      logs = parseQIP2005(qipfile.readlines)
    end

    if options[:u]
      @user = options[:u][0].to_sym
    else
      @user = :kmi9
    end

    if options[:uname]
      @username = options[:uname][0].strip
    else
      @username = "289754250"
    end

    if options[:out]
      fout = File.open(options[:out][0], "a+")
    else
      fout = File.open("#{@user}.data", "a+")
    end

    words = {}
    words[@user] = {}
    stat = {}
    stat[@user] = {}

    words[@user] = logs[@username].map{|i| i.split(/[^а-яА-Яa-zA-Z\-]+/u).map{|j| j.strip}.delete_if{|i| i.size < 1}}
    words[@user].each do |word|
      word.each do |w|
        w = Unicode.downcase w
        stat[@user][w] += 1 rescue stat[@user][w] = 1
      end
    end

    sort = stat[@user].sort{|i,j| i[1] <=> j[1]}
    sort.each{|i| fout.puts "#{i[0]}: #{i[1]}"}
    fout.close
  end
  
  def complex arg
    1
  end
  def read_all_in_dir dir, fmd5
    if File.file? dir.strip
      f = File.open(dir)
      unless check_file fmd5, f
        puts "File repeated."
        return []
      else
        return f.readlines
      end
    else
      lines ||= []
      Dir.open(dir.strip).each do |d|
        lines += read_all_in_dir(File.join(dir, d), fmd5) if d != "." and d != ".."
      end
      return lines
    end
  end

  def parseQIP2005 strs_to_parse
    msgs = {}
    str = nil
    username = nil
    strs_to_parse.each do |s|
      if s =~ /^-{5,}/u
        if username and str
          msgs[username] ||= []
          msgs[username] << str
        end
        str = nil
        username = nil
      elsif s =~ /(.+) \(.+\)/u
        username = $1.strip
      else
        str += s + " " rescue str = s + " "
      end
    end
    msgs
  end

  def parseAdium xmls
    parseSomeStr xmls, /<message sender="(\d+)".*><span .*?>(.+)<\/span>/u
  end

  def parsePidginHTML strs_to_parse
    parseSomeStr strs_to_parse, /<font.*<b>(\d+):<\/b><\/font>(.+)<br\/>/u
  end

  def parseHotCoffeeHTML strs_to_parse
    parseSomeStr strs_to_parse, /<div class=mes id=event.*<div class=nick.*>(.+):<\/div>.*<div class=text>\n(.+)\n\s*<\/div>\n\s*<\/div>/mu
  end

  def parseHotCoffeeTxt strs_to_parse
    parseSomeStr strs_to_parse, /\[.*\]\s(.+):\n(.+)\n\n/mu
  end

  def parseSomeStr strs_to_parse, regexp #$1 -- username, $2 -- msg
    msgs = {}
    long_str = ""
    strs_to_parse.each do |str|
      if str =~ regexp or long_str =~ regexp
        username = $1
        text = $2
        if text.gsub!(/<([^\s]+)\s?.*>.*<\/\1>/, "").empty?
          long_str = ""
          next
        end
        msgs[username] ||= []
        msgs[username] << text
        long_str = ""
      else
        long_str += str
      end
    end
    msgs
  end

  def check_file fmd5, chfile
    md5s = []
    while s = fmd5.gets.strip
      md5s << s unless s.empty?
    end
    chfile.readlines.join("")
    allfilemd5 = MD5.md5 allfile
    if md5s.size > 0
      md5s.each do |hash|
        if hash == allfilemd5
          puts "This file was already wrote"
          return false
        end
      end
    end
    fmd5.puts allfilemd5
    return true
  end
  
end
#теория диалогов. Лотман, Бахтин, Библер...




















