admin = DatabaseUser.new({
  email: 'admin@example.com',
  username: 'admin',
  password: 'administrator',
  password_confirmation: 'administrator',
  name: 'Administrator',
  role: 'administrator'
})
admin.save

Status.create([{title: 'New', default: true}, {title: 'Assigned'}, {title: 'Closed', closed: true}])
System.create(name: 'Triage')
