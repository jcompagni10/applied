apps.forEach(app =>(
  $.get("https://progress.appacademy.io/me/jobberwocky/api/companies/search?query="+app.company).then(response => (
    response.find(r => r.name === app.company))
    || $.post({url:"/me/jobberwocky/api/companies",data:{company:{name: app.company}}})
  ).then(a => (
    $.post({url:"/me/jobberwocky/api/job_applications",data:{job_application:{company_id: a.id, ranking: 1, status: "applied", rejected: false, job_title: app.position, job_website: app.url, contact_email: app.email, applied_via: "email", }}})
  )).then(()=>alert("all done")).catch("something broke man")));
  