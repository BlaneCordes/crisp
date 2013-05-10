class Scrape

=begin urls to scrape
"http://salesweb.civilview.com/SalesListing.aspx"
"http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic"
"http://njcourts.judiciary.state.nj.us/web1/ACMSPA/"
=end

 agent = Mechanize.new
 page = agent.get("http://oprs.co.monmouth.nj.us/oprs/clerk/ClerkHome.aspx?op=basic")
 page_form = page.form("aspnetForm") 
 page_form.field_with(name: "ctl00$ContentPlaceHolder1$ddlMunTab2").option_with(value: "BRIELLE").click
 page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtFromTab2").option_with(value: "LISPEN").click
 page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtFromTab2").value= "02/09/2013"
 page_form.field_with(name: "ctl00$ContentPlaceHolder1$txtToTab2").value= "05/10/2013"
 button = page_form.button_with(:name => "ctl00$ContentPlaceHolder1$btnSearchTab2")
 response = agent.submit(page_form, button)
 puts response.body
end