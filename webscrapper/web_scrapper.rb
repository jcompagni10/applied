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
  "https://www.indeed.com/jobs?as_and=software+engineer&as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&salary=&radius=25&l=Texas&fromage=any&limit=50&sort=&psf=advsrch"
  # "https://www.indeed.com/jobs?q=software+engineer&l=Texas&limit=50&radius=25&start=50",
  # "https://www.indeed.com/jobs?q=software+engineer&l=Texas&limit=50&radius=25&start=100"
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
job_listing_url = 'https://www.indeed.com/viewjob?jk=63869f0a25b3e2eb&from=tp-serp&tk=1c3rin8hg1fq67fr'

def parse_listing(url)
  frontend = ["javasript", "react", "redux", "vue", "jquery", "bootstrap"]
  backend = ["php", "ruby", "rails", "python", "sql"]
  other = ["webpack", "git", "rspec", "capybara", "npm", "aws"]

  app = {}

  listing_page = HTTParty.get(url)
  parsed_listing = Nokogiri::HTML(listing_page)

  app["company"] = parsed_listing.css('.company')[0].children.text
  app["position"] = parsed_listing.css(".jobtitle font")[0].children.text


  frontend_match = []
  backend_match = []
  other_match = []
  matches = [frontend_match, backend_match, other_match]

  job_summary = parsed_listing.css('#job_summary')[0].text.downcase
  [frontend, backend, other].each_with_index do |arr, i|
    arr.each do |el|
      matches[i] << el if job_summary.include?(el)
    end
  end
  app[:fe_stack] = matches[0]
  app[:be_stack] = matches[1]
  app[:other_stack] = matches[1]
  app[:url] = url
  Application.create(app)
end

parse_listing('https://www.indeed.com/viewjob?jk=63869f0a25b3e2eb&from=tp-serp&tk=1c3rin8hg1fq67fr')

