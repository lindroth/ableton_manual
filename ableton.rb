require 'rubygems'
require 'nokogiri'   
require 'open-uri'


head = '<html class="arrangement-view en js no-flexbox canvas canvastext webgl no-touch geolocation postmessage websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths wf-futurapt-n3-active wf-futurapt-n4-active wf-futurapt-n5-active wf-active" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
      <script src="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/4521.js" async="" type="text/javascript"></script><script type="text/javascript" async="" src="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/dc.js"></script><script async="" src="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/gtm.js"></script><script async="" src="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/analytics.js"></script><script src="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/177626932.js"></script>
    
    <meta content="company" property="og:type">
    <meta content="https://cdn2-resources.ableton.com/80bA26cPQ1hEJDFjpUKntxfqdmG3ZykO/static/images/ableton-logo.png" property="og:image">
    <meta content="always" name="referrer">
    <meta content="telephone=no" name="format-detection">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" name="viewport">
    <meta content="Ableton makes Push and Live, hardware and software for music production, creation and performance. Ableton´s products are made to inspire creative music-making." name="description">
    <meta content="" name="keywords">
    

    
    
    <title> Arrangement View — Ableton Reference Manual Version 9 | Ableton</title>
    
    <link href="./Arrangement View — Ableton Reference Manual Version 9   Ableton_files/Arrangement View — Ableton Reference Manual Version 9   Ableton.html" rel="canonical">
    
    <link href="../../base.css" type="text/css" rel="stylesheet">
    <link href="../../site.css" type="text/css" rel="stylesheet">
    
    <div id=\'page\'>
    <div id=\'main\'>
<div class=\'mainbar for_help alt\'>'

footer = '</div>
</div>
</div>
</body>
</html>'

chapters = Array.new
index_head = "<html><body>"
index_footer = "</body></html>"
url = "https://www.ableton.com/en/manual/" 
page = Nokogiri::HTML(open(url))
buffer = page.css('#manual_toc')[0]
a = buffer.css('a')

a.each{|x|
	if(x['href'].end_with? "/" )
		chapters << x['href']
		x['href'] = '.' + x['href'] + 'index.html'
	else
		x['href'] = '.' + x['href'].gsub("#", "index.html#")
	end
}

File.open('index.html', 'w') { |file| file.write(index_head) }
File.open('index.html','a') {|f| buffer.write_xml_to f}
File.open('index.html', 'a') { |file| file.write(index_footer) }

chapters.uniq!

Dir.mkdir 'images' if !File.exists?('./images')
Dir.mkdir 'manual' if !File.exists?('./manual')

chapters.each{|chapter|
	url = "https://www.ableton.com/en" + chapter
	puts "getting url " + url
	page = Nokogiri::HTML(open(url))
	buffer = page.css('.content_panel')[0]

	a = buffer.css('a')

	a.each{|x|
		if(x['href'].end_with? "/" )
			#Link to other chapter
			x['href'] = '../../' + x['href'] + 'index.html'
		elsif(x['href'].start_with? "http")
			#Link outside of manual, let it be
		elsif(x['href'].start_with? "#")
			#Link to somewhere in the same chapter
			x['href'] = '../..' + chapter + x['href'].gsub("#", "index.html#")
		else
			#link to section in other chapter
			x['href'] = '../../' + x['href'].gsub("#", "index.html#")
		end
	}

	img = buffer.css('img')

	image_dir = 'images/' + chapter.split('/').last
	Dir.mkdir image_dir unless File.exists?(image_dir)
	
	img.each{|x|
		image_name = x['src'].split('/').last		
		full_image_path = image_dir + '/' + image_name		

		open(full_image_path, 'wb') do |file|
  			file << open(x['src']).read
		end

		x['src'] = '../../' + image_dir + "/" + image_name
	}

	d = '.' + chapter
	Dir.mkdir d unless File.exists?(d)
	File.open(d + 'index.html', 'w') { |file| file.write(head) }
	File.open(d + 'index.html','a') {|f| buffer.write_xml_to f}
	File.open(d + 'index.html', 'a') { |file| file.write(footer) }
}


