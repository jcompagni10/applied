require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

# Contains an array of urls to individual job listings
# Ex. https://www.indeed.com/cmp/Intel/jobs/Software-Engineer-fa339a82cf53db70
individual_jobs_url_array = []

# High level pages containing 50 job listings
pages = [
  # "https://www.indeed.com/jobs?as_and=software+engineer&as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=Texas&fromage=any&limit=50&sort=&psf=advsrch",
  # "https://www.indeed.com/jobs?q=software+engineer&l=Texas&limit=50&radius=25&start=50",
  "https://www.indeed.com/jobs?q=software+engineer&l=Texas&limit=50&radius=25&start=100"
]

pages.each do |page|
  page = HTTParty.get(page)

  parse_page = Nokogiri::HTML(page)


  parse_page.css('div h2 a').map do |el|
    link = el.attributes["href"].value
    individual_jobs_url_array << link
  end
end
# end of getting individual job listing links

# An array of hashes. Each hash refers to a job and contains:
# company title, job title, website, email, 
job_details_array = []

domain_name = "https://www.indeed.com"
job_listing_url = domain_name + individual_jobs_url_array[1]

listing_page = HTTParty.get(job_listing_url)

parse_listing = Nokogiri::HTML(listing_page)

job_info = Hash.new

job_info["company_name"] = parse_listing.css('td div span')

Pry.start(binding)
