require 'cora'
require 'siri_objects'
require 'pp'

# Examples: 
#   Watch Tivo Everywhere
#   Watch Apple in Basement

class SiriProxy::Plugin::Hdmi  < SiriProxy::Plugin
  attr_accessor :roomHash
  attr_accessor :sourceHash
  attr_accessor :ip

  def initialize(config)
    @aRooms   = Hash.new
    @aSources = Hash.new
    @aRooms   = config["roomHash"]
    @aSources = config["sourceHash"]
    @deviceIp = config["ip"]
	@aSourceApp = config["sourceApp"]
	@baseUrl	= config["baseUrl"]

  end

  
  listen_for /(?:Watch|Launch) (.+)(?: ?TV)? (?:every where|everywhere)/i do |source|

    # Sanity check, make sure Source is valid ... if not list valid sources and ask again
    source = check_hash(source.downcase, @aSources)

	puts "Controlling: #{@deviceIp}"
	
    say "Watching #{source} Everywhere" #say something to the user!

    puts "**************************"
    dev = @aSources[source].to_s()

    for room in 1..4
	  puts "loop"
      cmd = room.to_s() + dev
      puts cmd
      `echo #{cmd} | nc #{@deviceIp} 4999`
      sleep 0.5
    end
	
	# Launch an App if defined
	if @aSourceApp.has_key?(source)
		launch(source, @baseUrl, @aSourceApp[source])
	end

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  # 
  listen_for /(?:Watch|Launch) (\S+)(?: ?TV)? (?:in|and)(?: the)? (.*)/i do |source,room|

    # Sanity check, make sure Source is valid ... if not list valid sources and ask again
    source = check_hash(source.downcase, @aSources)
    room   = check_hash(room.downcase, @aRooms)
	
	say "Watching #{source} in the #{room}" #say something to the user!

    puts "**************************"
    cmd = @aRooms[room].to_s() + @aSources[source].to_s()
    puts cmd

    `echo #{cmd} | nc #{@deviceIp} 4999`
	# Launch an App if defined

	if @aSourceApp.has_key?(source)
		launch(source, @baseUrl, @aSourceApp[source])
	end

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  def check_hash(searchKey, generalHash)
	puts "Validating: #{searchKey}"

	if generalHash.has_key?(searchKey)
		return searchKey	
	else
		say "Sorry, I could not find anything named #{searchKey}."
		say "Here is the list of options."
		generalHash.each_key {|searchKey| say searchKey.capitalize}
		searchKey = ask "Which would you like to choose?"  
		check_hash(searchKey.downcase.strip, generalHash)
	end

  end

end


####
#### For auto launching an Application
class OpenLink < SiriObject
	def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	end
end

def launch(appName, baseUrl, appUrl)
 
	# Create a URL redirect file to launch App in current host's Apache dir (must be writable by siriproxy user!)
  	File.open("/var/www/" + appName + ".html", "w") do |file|
		file.puts "<html><head><title>IU Webmaster redirect</title> <META http-equiv='refresh' content='0;URL=#{appUrl}'> </head> </html>" 
	end

	fullUrl = baseUrl + appName + '.html'
	add_property_to_class(OpenLink, :ref)
	sleep (4)
	view = OpenLink.new(fullUrl.gsub("//",""))
	send_object view
end

