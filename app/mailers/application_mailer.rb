class ApplicationMailer < ActionMailer::Base
  default from: 'jcompagni@gmail.com'

  fit = {
    productivity: "If its not not already apparent, productivity and efficient workflow is very important to me, so I would be honored to work at a company whose core mission is building innovative tools to allow companies to work smarter.",
    food: "Sharing good food with those around me has always been an important part of my life. Before transitioning into working full time as web developer I worked as a cook on an oil rig. So I am incredibly passionate about leveraging technology to make great food more easily accessible.",
    default: "If its not not already apparent, I am very passionate about using technology to develop creative solutions to real problems, so I would be honored to work at a company where inovation is held in such high regard."
  }
  purpose = {
    productivity: "has been been a pioneer in changing the way we use technology to be more productive.",
    Food: "has been been a pioneer in changing the way we use technology to interact find and interact with our food.",
    default: "puts an emphasis on finding creative ways solve real problems"
  }
  def application_email(app)
    @position = app.position
    @company = app.company
    @contact_name = app.contact_name
    @fit_snippet = fit[app.tag] || fit[:default]
    @purpose_snippet = purpose[app.tag] || purpose[:default]
    front_end_snippet = front_end_snippet(app.fe_stack)
    back_end_snippet = back_end_snippet(app.be_stack)
    other_tech_snippet = other_tech_snippet(app.other_stack)
    @stack_snippet = [front_end_snippet, back_end_snippet, other_tech_snippet].join (" ")
    cover_letter = WickedPdf.new.pdf_from_string(
      # render_to_string('app/views/cover_letters/default.html', layout: false)
      render('cover_letters/standard', layout: false, locals: { app: app })
    )

    mail.attachments['julian_compagni_portis_resume.pdf'] = File.read('app/assets/images/julian_compagni_portis_resume.pdf')
    mail.attachments['Julian_compagni_portis_cover_letter.pdf'] = cover_letter
    mail(to: app.email, subject: app.position)
  end

  def stringify(stack, values)
    stack.map { |tech| values[tech] }.uniq!
    if stack.length == 1
      return stack[0]
    else
      last = stack.pop
      stack = stack.join(', ')
      stack + " and " + last
    end
  end

  def front_end_snippet(fe_stack)
    techs = { react: "React/Redux", redux: "React/Redux", vue: 'Vue.Js', jquery: 'JQuery', boostrap: 'Bootstrap' }
    base = "I enjoy writing vanilla JavaScript, but I’m also no stranger to frontend libraries and frameworks like "

    if fe_stack.empty? 
      fe_stack = ['react', 'vue', 'jquery']
    end
    fe_stack = stringify(fe_stack, techs)

    base + fe_stack + "."
  end

  def back_end_snippet(be_stack)
    base = "On the backend I am very adept in "
    techs = { ruby: "Ruby", rails: "Ruby on Rails", python: "Python", php: "PHP", sql: "SQL" }
    if be_stack.empty? 
      be_stack = ['Ruby', 'Python', 'PHP']
    end
    be_stack = stringify(be_stack, techs)

    base + be_stack + "."
  end

  def other_tech_snippet(other_stack)
    base = "I have also worked extensively with "
    techs = { webpack: "Webpack", git: "Git", rspec: "Rspec", npm: "Capybara", npm: "package managers like NPM", aws: "many of the services in the AWS ecosystem"}
    if other_stack.empty? 
      return ""
    end
    other_stack = stringify(other_stack, techs).gsub("and", "as well as")
    base + other_stack + "."
  end

end


