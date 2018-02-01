class Application < ApplicationRecord
  serialize :be_stack
  serialize :fe_stack
  serialize :other_stack

  def self.title_case(title)
    title.downcase
      .split(" ")
      .map {|word| word[0] = word[0].upcase; word}
      .join(" ")
  end

  def self.add_emails
    unsent = Application.where("email is null")
    unsent.each do |app|
      puts (app.company+", " + app.url)
      email = gets.chomp
      puts "name"
      name = gets.chomp
      app.update(email: email, contact_name: name)
    end
  end

  def self.angel_jobs
    jerbs = ["https://angel.co/coscreen/jobs/310423-Full-Stack-Developer",
    "https://angel.co/mazedon/jobs/312633-senior-software-engineer-education-platform",
    "https://angel.co/originate/jobs/157149-sr-software-engineer",
    "https://angel.co/coinlist/jobs/305913-full-stack-engineer",
    "https://angel.co/trackin/jobs/64634-full-stack-engineer",
    "https://angel.co/mobydish-1/jobs/293485-full-stack-engineer",
    "https://angel.co/nava-pbc/jobs/124917-software-engineer",
    "https://angel.co/leap-ai-1/jobs/302445-full-stack-engineer",
    "https://angel.co/adroll/jobs/302087-senior-full-stack-engineer-integrations",
    "https://angel.co/algolia/jobs/50672-solutions-engineer"]
    jerbs.each do |job|
      app = {}
      post_str = job.split('/')[-1]
      app[:position] = /-([a-zA-z-]+)/.match(post_str)[1].split('-').join(" ")
      app[:company] = job.split("/")[-3].delete("-1")
      app[:url] = job
      app[:sent] = false
      app[:source] = "angel list"
      Application.create(app)
    end
  end
  
  def self.pull_sites
    list = File.open(Dir.glob("#{Rails.root}/app/models/app_list.txt")[0])
    list.readlines.each do |line|
      url, tag = line.chomp.split(" ")
      Application.parse_listing_indeed(url, tag)
    end
  end

  def self.parse_listing_angel_list(url, tag = nil)
    frontend = ["javasript", "react", "redux", "vue", "jquery", "bootstrap"]
    backend = ["php", "ruby", "rails", "python", "sql"]
    other = ["webpack", "git", "rspec", "capybara", "google analytics", "npm", "aws"]
  
    app = {}
  
    listing_page = HTTParty.get(url)
    parsed_listing = Nokogiri::HTML(listing_page)
  
    app["company"] = parsed_listing.css('.c-navbar-item')[0].children.text
    position = parsed_listing.css(".u-colorGray3")[0].children.text
      .split(',')[0]
      .split('(')[0]
    
    app["position"] = title_case(position)
  
    frontend_match = []
    backend_match = []
    other_match = []
    matches = [frontend_match, backend_match, other_match]
  
    job_summary = parsed_listing.css('#layouts-base-body')[0].text.downcase
    [frontend, backend, other].each_with_index do |arr, i|
      arr.each do |el|
        matches[i] << el if job_summary.include?(el)
      end
    end
    app[:fe_stack] = matches[0]
    app[:be_stack] = matches[1]
    app[:other_stack] = matches[2]
    app[:url] = url
    app[:sent] = false
    app[:tag] = tag
    Application.create(app)
  end

  def self.parse_listing_indeed(url, tag = nil)
    frontend = ["javasript", "react", "redux", "vue", "jquery", "bootstrap"]
    backend = ["php", "ruby", "rails", "python", "sql"]
    other = ["webpack", "git", "rspec", "capybara", "google analytics", "npm", "aws"]
  
    app = {}
  
    listing_page = HTTParty.get(url)
    parsed_listing = Nokogiri::HTML(listing_page)
    app["company"] = parsed_listing.css('.company')[0].children.text
    position = parsed_listing.css(".jobtitle font")[0].children.text
      .split(',')[0]
    
    app["position"] = title_case(position)
  
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
    app[:other_stack] = matches[2]
    app[:url] = url
    app[:sent] = false
    app[:tag] = tag
    Application.create(app)
    puts "done"
  end


  def self.parse_listing_SO(url, tag = nil)
    frontend = ["javasript", "react", "redux", "vue", "jquery", "bootstrap"]
    backend = ["php", "ruby", "rails", "python", "sql"]
    other = ["webpack", "git", "rspec", "capybara", "google analytics", "npm", "aws"]
  
    app = {}
  
    listing_page = HTTParty.get(url)
    parsed_listing = Nokogiri::HTML(listing_page)
  
    app["company"] = parsed_listing.css('.employer')[0].children.text
    position = parsed_listing.css(".title.job-link")[0].children.text
      .split(',')[0]
    
    app["position"] = title_case(position)
  
    frontend_match = []
    backend_match = []
    other_match = []
    matches = [frontend_match, backend_match, other_match]
  
    job_summary = parsed_listing.css('.-job-description')[0].text.downcase
    [frontend, backend, other].each_with_index do |arr, i|
      arr.each do |el|
        matches[i] << el if job_summary.include?(el)
      end
    end
    app[:fe_stack] = matches[0]
    app[:be_stack] = matches[1]
    app[:other_stack] = matches[2]
    app[:url] = url
    app[:source] = "stack overflow"
    app[:sent] = false
    app[:tag] = tag
    Application.create(app)
    puts "done"
  end


end
