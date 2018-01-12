app = apps[0];
$.get("https://progress.appacademy.io/me/jobberwocky/api/companies/search?query="+app.company_name)
.then(response => (
  response.find(r => r.name === app.company_name)
  || $.post({url:"/me/jobberwocky/api/companies",data:{company:{name: app.company_name}}})
))
.then(a => (
  $.post({url:"/me/jobberwocky/api/job_applications",data:{job_application:{company_id: a.id, ranking: 1, status: "applied", rejected: false, job_title: app.position, job_website: app.url, contact_email: app.email, applied_via: "email", }}})
))
.then(alert("all done"))
.catch("something broke man");



apps = [{"id":null,"email":"jcompagni@gmail.com","company":"Docker Co","position":"Docker Technician","url":"www.juliancompagniportis.com"}]; app = apps[0]; $.get("https://progress.appacademy.io/me/jobberwocky/api/companies/search?query="+app.company_name) .then(response => ( response.find(r => r.name === app.company_name) || $.post({url:"/me/jobberwocky/api/companies",data:{company:{name: app.company_name}}}) )) .then(a => ( $.post({url:"/me/jobberwocky/api/job_applications",type:"POST",data:{job_application:{company_id: a.id, ranking: 1, status: "applied", rejected: false, job_title: app.position, job_website: app.url, contact_email: app.email, applied_via: "email", }}}) )) .then(alert("all done")) .catch("something broke man");


apps = [{"id":null,"email":"jcompagni@gmail.com","company":"Docker Co","position":"Docker Technician","url":"www.juliancompagniportis.com"}]; app = apps[0]; $.get("https://progress.appacademy.io/me/jobberwocky/api/companies/search?query="+app.company_name).then(response => ( response.find(r => r.name === app.company_name) || $.post({url:"/me/jobberwocky/api/companies",data:{company:{name: app.company_name}}}) )).then(a => ( $.post({url:"/me/jobberwocky/api/job_applications",data:{job_application:{company_id: a.id, ranking: 1, status: "applied", rejected: false, job_title: app.position, job_website: app.url, contact_email: app.email, applied_via: "email", }}})).then(alert("all done")).catch("something broke man");