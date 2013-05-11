class Scrape

=begin urls to scrape
"http://salesweb.civilview.com/SalesListing.aspx"
"http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic"
"http://njcourts.judiciary.state.nj.us/web1/ACMSPA/"
=end
  def self.perform
     agent = Mechanize.new
     page = agent.get("http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic")
     page_form = page.form("aspnetForm") 
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$ddlMunTab2").option_with(value: "COLTS NECK").click
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$ddlDocTypeTab2").option_with(value: "LISPEN").click
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtFromTab2").value= "02/12/2013"
     page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtToTab2").value= "05/10/2013"
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
         pendens << line[index] + line[index + 1] + line[index + 2] + line[index + 3] + line[index + 4] + line[index + 5]
       end
     end
    pendens
  end
end