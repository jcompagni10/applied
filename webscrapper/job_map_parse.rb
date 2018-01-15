require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'
require 'clearbit'
require 'byebug'


job_map = [
  "cmpesc:'The University of Kansas Medical Center',cmplnk:'/q-The-University-of-Kansas-Medical-Center-l-Texas-jobs.html',loc:'Staff, TX',country:'US',zip:'',city:'Staff',title:'Web Developer'",
  "cmpesc:'EML Incorporated',cmplnk:'/q-EML-Incorporated-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Application Developer-Java'",
  "cmpesc:'Exeter Finance LLC',cmplnk:'/q-Exeter-Finance-l-Texas-jobs.html',loc:'Irving, TX 75039',country:'US',zip:'',city:'Irving',title:'Application Developer II'",
  "cmpesc:'NetCloudTek',cmplnk:'/q-NetCloudTek-l-Texas-jobs.html',loc:'Dallas, TX',country:'US',zip:'',city:'Dallas',title:'Entry Level Software Developer'",
  "cmpesc:'EML Incorporated',cmplnk:'/q-EML-Incorporated-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer'",
  "cmpesc:'Kinnser Software',cmplnk:'/q-Kinnser-Software-l-Texas-jobs.html',loc:'Austin, TX 78746',country:'US',zip:'',city:'Austin',title:'Associate Software Test Engineer'",
  "cmpesc:'The University of Texas Medical Branch',cmplnk:'/q-The-University-of-Texas-Medical-Branch-l-Texas-jobs.html',loc:'Galveston, TX 77551',country:'US',zip:'77551',city:'Galveston',title:'Programmer Analyst II - Inst for Translational Science'",
  "cmpesc:'JP Morgan Chase',cmplnk:'/q-JP-Morgan-Chase-l-Texas-jobs.html',loc:'Dallas, TX 75254',country:'US',zip:'75254',city:'Dallas',title:'Software Engineer - PL\/SQL'",
  "cmpesc:'Rackspace',cmplnk:'/jobs?q=Rackspace,+the+%231+managed+cloud+company&l=Texas',loc:'Windcrest, TX',country:'US',zip:'',city:'Windcrest',title:'Software Developer - Rackspace Private Cloud - Remote'",
  "cmpesc:'nFUZION',cmplnk:'/q-nFUZION-l-Texas-jobs.html',loc:'Dallas, TX',country:'US',zip:'',city:'Dallas',title:'Software Engineer'",
  "cmpesc:'Allstate',cmplnk:'/q-Allstate-l-Texas-jobs.html',loc:'Irving, TX 75015',country:'US',zip:'75015',city:'Irving',title:'ATSV - Application Developer - Java'",
  "cmpesc:'DEF-LOGIX INC',cmplnk:'/jobs?q=DEF-LOGIX&l=Texas',loc:'San Antonio, TX',country:'US',zip:'',city:'San Antonio',title:'Intern - Software Developer'",
  "cmpesc:'Apiece solutions',cmplnk:'/q-Apiece-solutions-l-Texas-jobs.html',loc:'West, TX',country:'US',zip:'',city:'West',title:'IT Software developer'",
  "cmpesc:'EvereTech',cmplnk:'/q-EvereTech-l-Texas-jobs.html',loc:'Fort Worth, TX 76108',country:'US',zip:'76108',city:'Fort Worth',title:'Software Engineer'",
  "cmpesc:'IBM',cmplnk:'/q-IBM-l-Texas-jobs.html',loc:'Austin, TX 73344',country:'US',zip:'73344',city:'Austin',title:'Software Developer'",
  "cmpesc:'Halff Associates',cmplnk:'/q-Halff-Associates-l-Texas-jobs.html',loc:'Richardson, TX 75081',country:'US',zip:'75081',city:'Richardson',title:'Software Developer- Richardson, TX'",
  "cmpesc:'Xpressdocs',cmplnk:'/q-Xpressdocs-l-Texas-jobs.html',loc:'Fort Worth, TX 76137',country:'US',zip:'',city:'Fort Worth',title:'Software Developer'",
  "cmpesc:'Labatt Food Service',cmplnk:'/q-Labatt-Food-Service-l-Texas-jobs.html',loc:'San Antonio, TX',country:'US',zip:'',city:'San Antonio',title:'Fullstack Software Developer'",
  "cmpesc:'Silicon Labs',cmplnk:'/q-Silicon-Labs-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer, Operations - New College Graduate'",
  "cmpesc:'SWBC',cmplnk:'/q-SWBC-l-Texas-jobs.html',loc:'San Antonio, TX',country:'US',zip:'',city:'San Antonio',title:'Application Developer'",
  "cmpesc:'Texas Tech University',cmplnk:'/q-Texas-Tech-University-l-Texas-jobs.html',loc:'Lubbock, TX',country:'US',zip:'',city:'Lubbock',title:'Programmer Analyst II'",
  "cmpesc:'Sabre',cmplnk:'/q-Sabre-l-Texas-jobs.html',loc:'Southlake, TX',country:'US',zip:'',city:'Southlake',title:'Contributor Software Development'",
  "cmpesc:'OwnLocal.com',cmplnk:'/q-OwnLocal.com-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer'",
  "cmpesc:'Reynolds and Reynolds',cmplnk:'/q-Reynolds-and-Reynolds-l-Texas-jobs.html',loc:'Fort Worth, TX',country:'US',zip:'',city:'Fort Worth',title:'Software Developer'",
  "cmpesc:'Avanade',cmplnk:'/q-Avanade-l-Texas-jobs.html',loc:'Dallas, TX',country:'US',zip:'',city:'Dallas',title:'Entry Level Software Engineer, Dallas, Houston'",
  "cmpesc:'DUMAC Business Systems, Inc.',cmplnk:'/q-DUMAC-Business-Systems-l-Texas-jobs.html',loc:'Fort Worth, TX',country:'US',zip:'',city:'Fort Worth',title:'Software Engineer I'",
  "cmpesc:'Paypal',cmplnk:'/q-Paypal-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Java Software Engineer'",
  "cmpesc:'Flywheel Building Intelligence',cmplnk:'/q-Flywheel-Building-Intelligence-l-Texas-jobs.html',loc:'Dallas, TX 75244',country:'US',zip:'75244',city:'Dallas',title:'Software Engineer (Full Stack)'",
  "cmpesc:'American Airlines',cmplnk:'/q-American-Airlines-l-Texas-jobs.html',loc:'Fort Worth, TX',country:'US',zip:'',city:'Fort Worth',title:'Team Lead, IT Applications'",
  "cmpesc:'Shelby Systems',cmplnk:'/q-Shelby-Systems-l-Texas-jobs.html',loc:'Richardson, TX',country:'US',zip:'',city:'Richardson',title:'Full-Stack Software Developer'",
  "cmpesc:'UST Global Inc.',cmplnk:'/q-UST-Global-l-Texas-jobs.html',loc:'San Antonio, TX',country:'US',zip:'',city:'San Antonio',title:'Software Engineer'",
  "cmpesc:'DELL',cmplnk:'/q-DELL-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer'",
  "cmpesc:'StackPath',cmplnk:'/q-StackPath-l-Texas-jobs.html',loc:'Dallas, TX 75201',country:'US',zip:'75201',city:'Dallas',title:'Software Engineer - Full Stack'",
  "cmpesc:'Southwest Research Institute',cmplnk:'/q-Southwest-Research-Institute-l-Texas-jobs.html',loc:'San Antonio, TX 78238',country:'US',zip:'',city:'San Antonio',title:'STUDENT ANALYST - SOFTWARE DEVELOPMENT'",
  "cmpesc:'National Oilwell Varco',cmplnk:'/q-National-Oilwell-Varco-l-Texas-jobs.html',loc:'Anderson, TX',country:'US',zip:'',city:'Anderson',title:'Software Developer'",
  "cmpesc:'Ministry Brands',cmplnk:'/q-Ministry-Brands-l-Texas-jobs.html',loc:'Richardson, TX 75080',country:'US',zip:'75080',city:'Richardson',title:'Full-Stack Software Developer'",
  "cmpesc:'Self Lender',cmplnk:'/q-Self-Lender-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer'",
  "cmpesc:'Capgemini',cmplnk:'/q-Capgemini-l-Texas-jobs.html',loc:'Texas',country:'US',zip:'',city:'',title:'Software Engineer Lead'",
  "cmpesc:'Capgemini',cmplnk:'/q-Capgemini-l-Texas-jobs.html',loc:'Texas',country:'US',zip:'',city:'',title:'Software Engineer'",
  "cmpesc:'Golden Frog',cmplnk:'/q-Golden-Frog-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Backend Developer'",
  "cmpesc:'Butler America Career Portal',cmplnk:'/q-Butler-America-Career-Portal-l-Texas-jobs.html',loc:'Texas',country:'US',zip:'',city:'',title:'Software Engineer Level 2'",
  "cmpesc:'Liquid Web',cmplnk:'/q-Liquid-Web-l-Texas-jobs.html',loc:'San Antonio, TX 78205',country:'US',zip:'78205',city:'San Antonio',title:'Software Engineer'",
  "cmpesc:'LabCorp',cmplnk:'/q-LabCorp-l-Texas-jobs.html',loc:'San Antonio, TX',country:'US',zip:'',city:'San Antonio',title:'IT Programmer'",
  "cmpesc:'Silvercar',cmplnk:'/q-Silvercar-l-Texas-jobs.html',loc:'Austin, TX 78741',country:'US',zip:'',city:'Austin',title:'Full Stack Developer'",
  "cmpesc:'OwnLocal.com',cmplnk:'/q-OwnLocal.com-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Front End Software Engineer'",
  "cmpesc:'Petrolink International',cmplnk:'/q-Petrolink-International-l-Texas-jobs.html',loc:'Houston, TX',country:'US',zip:'',city:'Houston',title:'Software Developer'",
  "cmpesc:'National Oilwell Varco',cmplnk:'/q-National-Oilwell-Varco-l-Texas-jobs.html',loc:'Cedar Park, TX 78613',country:'US',zip:'',city:'Cedar Park',title:'Software Engineer'",
  "cmpesc:'United Airlines Inc.',cmplnk:'/q-United-Airlines-l-Texas-jobs.html',loc:'Houston, TX 77002',country:'US',zip:'77002',city:'Houston',title:'Analyst - Information Technology'",
  "cmpesc:'Vecktre Interactive LLC',cmplnk:'/q-Vecktre-Interactive-l-Texas-jobs.html',loc:'Houston, TX',country:'US',zip:'',city:'Houston',title:'Mobile Gaming App Developer'",
  "cmpesc:'Conversable',cmplnk:'/q-Conversable-l-Texas-jobs.html',loc:'Austin, TX',country:'US',zip:'',city:'Austin',title:'Software Engineer'"
]

search_strings = [
  "recruiter",
  "recruitment",
  "Campus Recruiter",
  "Campus Recruitment Manager",
  "Candidate Attraction Specialist",
  "Candidate Attraction Specialist",
  "Chief People Officer",
  "Chief Talent Officer",
  "College Recruiter",
  "Contingent Workforce Manager",
  "Contract Recruiter",
  "Corporate Recruiter",
  "Corporate Recruitment Lead",
  "Deputy Head of Recruitment",
  "Direct Recruiter",
  "Direct Recruitment Specialist",
  "Director – Executive Recruitment",
  "Director – Strategic Resourcing",
  "Executive Recruiter",
  "Executive Recruiting Leader",
  "Executive Recruitment Manager",
  "Executive Search Lead",
  "Executive Talent Acquisition",
  "Executive Talent Sourcing Manager",
  "Experienced Hire Recruiter",
  "Experienced Hire Recruitment Manager",
  "External Candidate Developer",
  "Global Graduate Resourcing Manager",
  "Global Program Manager – Employer Branding",
  "Global Talent Selection Manager",
  "Graduate Recruiter",
  "Graduate Recruitment Advisor",
  "Graduate Recruitment Manager",
  "Head of Campus Recruitment",
  "Head of Client Services (RPO)",
  "Head of Graduate Recruitment",
  "Head of Graduates, Apprentices, & Resourcing",
  "Head of In-house Executive Search",
  "Head of Projects – Talent Acquisition",
  "Head of Recruitment",
  "Head of Recruitment Operations",
  "Head of Recruitment Projects",
  "Head of Recruitment Strategy",
  "Head of Resourcing",
  "Head of RPO Projects",
  "Head of Senior Hires Recruitment",
  "Head of Student Recruitment",
  "Head of Talent Acquisition",
  "Headhunter",
  "HR Manager – Recruitment",
  "HR Manager – Resourcing",
  "HR Staffing Specialist",
  "Hybrid Recruiter",
  "In-house Recruiter",
  "Inhouse Recruitment Consultant",
  "Internal Recruiter",
  "Internal Recruiter – Interns & Apprenticeships",
  "Internal Recruitment Manager",
  "Internal Talent Acquisition Manager",
  "Internet Recruiter",
  "Lateral Recruiter",
  "Lateral Recruitment Manager",
  "Lead Recruiter",
  "Lead Sourcing Consultant",
  "Lead Talent Scout",
  "Leadership Recruiter",
  "Manager – Executive Search",
  "Manager – Talent Systems & Resourcing",
  "MBA Recruiter",
  "MBA Recruitment Manager",
  "Onsite Account Director/RPO Account Director",
  "Onsite Account Manager/RPO Account Manager",
  "People Manager",
  "Principal Delivery Consultant",
  "Principal Recruitment Specialist",
  "Recruiter",
  "Recruiter / Sourcer",
  "Recruiting Coordinator",
  "Recruiting Researcher",
  "Recruitment & Engagement Manager",
  "Recruitment Account Manager",
  "Recruitment Advisor",
  "Recruitment Business Partner",
  "Recruitment Consultant",
  "Recruitment Director",
  "Recruitment Executive",
  "Recruitment Lead",
  "Recruitment Manager",
  "Recruitment Marketing Manager",
  "Recruitment Officer",
  "Recruitment Operations Manager",
  "Recruitment Partner",
  "Recruitment Program Manager",
  "Recruitment Representative",
  "Recruitment Specialist",
  "Recruitment Strategy & Planning Manager",
  "Recruitment Team Lead",
  "Recruitment Team Leader",
  "Researcher",
  "Resource Consultant",
  "Resource Partner",
  "Resourcer",
  "Resourcing & Recruitment Manager",
  "Resourcing Advisor",
  "Resourcing Associate",
  "Resourcing Business Partner",
  "Resourcing Director",
  "Resourcing Lead",
  "Resourcing Manager",
  "Resourcing Partner",
  "Resourcing Program Lead",
  "Resourcing Relationship Manager",
  "Resourcing Specialist",
  "RPO Lead",
  "Senior Recruiter",
  "Service Delivery Manager",
  "Sourcer",
  "Sourcing Advisor",
  "Sourcing Director",
  "Sourcing Manager",
  "Sourcing Specialist",
  "Sourcing Team Leader",
  "Staffing Channels Intelligence Researcher",
  "Staffing Consultant",
  "Staffing Manager",
  "Staffing Specialist",
  "Strategic Recruitment Lead",
  "Strategic Sourcing Recruiter",
  "Supplier Relationship Manager",
  "Talent Acquisition Administrator",
  "Talent Acquisition Advisor",
  "Talent Acquisition Associate",
  "Talent Acquisition Business Partner",
  "Talent Acquisition Consultant",
  "Talent Acquisition Coordinator",
  "Talent Acquisition Director",
  "Talent Acquisition Lead",
  "Talent Acquisition Leader",
  "Talent Acquisition Manager",
  "Talent Acquisition Operations Manager",
  "Talent Acquisition Partner/Business Partner – Talent Acquisition",
  "Talent Acquisition Program Manager",
  "Talent Acquisition Recruiter",
  "Talent Attraction Consultant",
  "Talent Attraction Specialist",
  "Talent Consultant – Executive Search",
  "Talent Data & Research Specialist",
  "Talent Engagement Advisor",
  "Talent Identification Manager",
  "Talent Magnet",
  "Talent Partner",
  "Talent Recruiter",
  "Talent Scout",
  "Talent Search Manager",
  "Talent Sourcer",
  "Talent Sourcing Lead",
  "Talent Sourcing Lead",
  "Talent Sourcing Manager",
  "Talent Sourcing Partner",
  "Talent Sourcing Specialst",
  "Talent Specialist",
  "University Relations Recruiter",
  "University Staffing Consultant",
  "Vendor Management Specialist -Talent Acquisition",
  "Vendor Manager – Recruitment"
]

Clearbit.key = 'sk_64096946f6d2ca64455f5f052ff33bbe'

job_arr = []

# iterates through each company - title pair
job_map.each do |el|
  job_hash = Hash.new
  job_hash["company_title"] = el[/#{"cmpesc:'"}(.*?)#{"'"}/m, 1]
  job_hash["job_title"] = el[/#{"title:'"}(.*?)#{"'"}/m, 1]

  # Hunter API to get email addresses from company name
  hunter_email_api = "https://api.hunter.io/v2/domain-search?company=#{job_hash["company_title"]}&api_key=e5b769ebaf7501769bb7104adafcc21928aae5e9&limit=100"
  page = HTTParty.get(hunter_email_api)

  job_hash["all_contacts"] = []

  # Iterates through all emails to find the employee information
  emails = page.parsed_response["data"]["emails"].map { |json| json["value"] }
  emails.each do |email|
    response = Clearbit::Enrichment.find(email: "#{email}", stream: true)
    job_hash["all_contacts"] << response
  end

  job_hash["contacts"] = []

  # Iterates thorugh contact info to find employees with recruiter related emails
  job_hash["all_contacts"].each do |contact|
    next if contact["person"].nil? || contact["person"]["employement"].nil? || contact["person"]["employement"]["title"]
    contact_title = contact["person"]["employment"]["title"]
    contact_full_name = contact["person"]["name"]["fullName"]
    contact_email = contact["person"]["email"]

    if search_strings.any? { |string| contact_title.downcase.include?(string.downcase) }
      job_hash["contacts"] << [contact_full_name, contact_title, contact_email]
    end
  end
    
  
  job_arr << job_hash
  p job_hash
end




Pry.start(binding)