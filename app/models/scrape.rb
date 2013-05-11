class Scrape

=begin urls to scrape
"http://salesweb.civilview.com/SalesListing.aspx"
"http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic"
"http://njcourts.judiciary.state.nj.us/web1/ACMSPA/"
=end

TOWNS = []

  def self.perform
     agent = Mechanize.new
     page = agent.get("http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic")
     page_form = page.form("aspnetForm") 
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$ddlMunTab2").option_with(value: "COUNTY WIDE").click
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$ddlDocTypeTab2").option_with(value: "LISPEN").click
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtFromTab2").value= (Time.now - 1.week).strftime('%m/%d/%Y')
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtToTab2").value= (Time.now - 1.day).strftime('%m/%d/%Y')
     button = page_form.button_with(:name => "ctl00$ContentPlaceHolder1$btnSearchTab2")
     response = agent.submit(page_form, button)
     puts response.body

     pendens = []
     string = response.body.to_s
     lines = []
     string.each_line do |line|
       lines << line
     end
     lines.each_with_index do |line, index|
       if line.match(/LIS/)
         pendens << lines[index] + lines[index + 1] + lines[index + 2] + lines[index + 3] + lines[index + 4] + lines[index + 5] +
                    lines[index + 6] + lines[index + 7] + lines[index + 8]
       end
     end
    pendens
  end

  def self.scrape
    data = Scrape.perform
    answers = []
    data.each do |line|
      answers << parse(line)
    end
    answers
  end

  def self.parse(string)
    no_tabs = string.gsub! /\t/, ''
    no_rows = no_tabs.gsub! /\r/, ''
    no_rows = no_rows.gsub! /\n/, ''
    house = no_rows.scan(/[A-Z]+\s[A-Z]+/)
    dates = no_rows.scan(/\d+\/\d+\/\d+/)
    house << dates
  end

end