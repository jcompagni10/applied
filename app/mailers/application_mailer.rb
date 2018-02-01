class ApplicationMailer < ActionMailer::Base
  default from: 'jcompagni@gmail.com'

  def fit
    {
      productivity: "If its not not already apparent, productivity and efficient workflow is very important to me, so I would be honored to work at a company whose core mission is building innovative tools to allow companies to work smarter.",
      food: "Sharing good food with those around me has always been an important part of my life. Before transitioning into working full time as web developer I worked as a cook on an oil rig. So I am incredibly passionate about leveraging technology to make great food more easily accessible.",
      iot: "If its not not already apparent, using technology to make life easier is very important to me. I think IoT is the next big frontier as we look to simplify our lives and streamline out daily activities. I would be honored to work at a company whose core mission is building innovative tools to allow people to work smarter.",
      advertising: "Before working as a freelance web developer I interned at the Goodby Silverstein Ad Agency. That experience has had a profound effect on how I think about building and marketing websites. Furthermore in much of my past work I have done a lot of SEO and SEA. I have also worked extensively with online advertising tools like Google adWords and Facebook Ads.",
      fintech: "In addition to my background in web development, I have a true passion for business and economics. I graduated with a BA in economics and have been involved in the advertising and business operations of several companies. Even as a web developer I am confident that this background will allow me to write code with a greater focus on the end product.",
      blockchain: "I have been using blockchain technology and crypto-currency for the last 5 years. I have no doubt that blockchain will play crucial role in revolutionizing our economy and the way we track transactional information. I would be honored to be a part of that revolution.",
      travel: "I have always been passionate about travel and exploring the world around me. I would be honored to work in a role where I can help facilitate that experience for others.",
      ecommerce: "As a freelance developer I have worked extensivley in the eCommerce space. Over the last 3 years I have built a number of eCommerce platforms and am familiar with many of the challenges particular to the eCommerce industry.",
      data: "I am more convinced than ever that the way we manage data is quickly becoming outdated. I would be honored to work a company that is on the forefront of this revolution. .",
      default: "If its not not already apparent, I am very passionate about using technology to develop creative solutions to real problems, so I would be honored to work at a company where innovation is held in such high regard."
    } 
  end

  def purpose
    {
      productivity: "has been been a pioneer in changing the way we use technology to be more productive.",
      travel: "has been a pioneer in chaning the way we use technology to travel.",
      food: "has been been a pioneer in changing the way we use technology to interact find and interact with our food.",
      iot: "has been been a pioneer in changing the way we interact with everyday objects and technology.",
      data: "is pioneering the future of digital data storage and management.",
      ecommerce: "is pioneering the future of eCommerece, and revolutionizing the digitial shopping experience.",
      blockchain: "is pioneering the future of blockchain technology.",
      default: "puts an emphasis on finding creative ways solve real problems."
      
    }
  end

  def application_email(app)
    @position = app.position.split('(')[0]
    .split(',')[0]
    .split(" ").take(4)
    .join(" ")
    @company = Application.title_case(app.company)
    @contact_name = app.contact_name
    app.tag = "default" if app.tag.nil?
    @fit_snippet = fit[app.tag.to_sym] || fit[:default]
    @purpose_snippet = purpose[app.tag.to_sym] || purpose[:default]
    front_end_snippet = front_end_snippet(app.fe_stack)
    back_end_snippet = back_end_snippet(app.be_stack)
    other_tech_snippet = other_tech_snippet(app.other_stack)
    @stack_snippets = [front_end_snippet, back_end_snippet, other_tech_snippet].join (" ")
    cover_letter = WickedPdf.new.pdf_from_string(
      # render_to_string('app/views/cover_letters/default.html', layout: false)
      render('cover_letters/standard', layout: false, locals: { app: app })
    )
    cover_letter_title = 
    "julian_"+@company.gsub("The ", "")
    .split(" ")
    .take(3)
    .join('_') + "_letter.pdf"
    mail.attachments['julian_compagni_portis_resume.doc'] = File.read('app/assets/images/julian_compagni_portis_resume.doc')
    mail.attachments[cover_letter_title] = cover_letter
    mail(to: app.email, subject: app.position)
  end

  def stringify(stack, values)
    techs = stack.map { |tech| values[tech.to_sym] }.uniq
    if techs.length == 1
      return techs[0]
    else
      last = techs.pop
      techs = techs.join(', ')
      techs + " and " + last
    end
  end

  def front_end_snippet(fe_stack = [])
    techs = { react: "React/Redux", redux: "React/Redux", vue: 'Vue.Js', jquery: 'JQuery', bootstrap: 'Bootstrap', html: "HTML", css: "CSS3" }
    base = "I enjoy writing vanilla JavaScript, but I have also worked extensively with frontend libraries and frameworks like "
    if fe_stack.nil? || fe_stack.empty? 
      fe_stack = ['react', 'vue', 'jquery']
    end
    fe_stack = stringify(fe_stack, techs)
    front_end_snippet if fe_stack.nil?
    base + fe_stack + "."
  end

  def back_end_snippet(be_stack = [])
    base = "On the backend I am very adept in "
    techs = { ruby: "Ruby", rails: "Ruby on Rails", python: "Python", php: "PHP", sql: "SQL" }
    if be_stack.nil? || be_stack.empty?
      be_stack = ['ruby', 'php', 'python']
    end
    be_stack = stringify(be_stack, techs)

    base + be_stack + "."
  end

  def other_tech_snippet(other_stack = [])
    base = "I have also worked extensively with "
    techs = { webpack: "Webpack", git: "Git", rspec: "Rspec", capybara: "Capybara", npm: "package managers like NPM", aws: "many of the services in the AWS ecosystem"}
    if other_stack.nil? || other_stack.empty?
      return ""
    end
    other_stack = stringify(other_stack, techs).gsub("and", "as well as")
    base + other_stack + "."
  end

end


