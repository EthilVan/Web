ActiveRecord::Base.configurations[:development] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :pool      => 5,
  :host      => 'localhost',
  # A changer :
  :database  => 'database',
  :username  => 'username',
  :password  => 'password',
}

# Necessaire uniquement pour les tests unitaires
ActiveRecord::Base.configurations[:test] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :pool      => 5,
  :host      => 'localhost',
  # A changer :
  :database  => 'database',
  :username  => 'username',
  :password  => 'password',
}
