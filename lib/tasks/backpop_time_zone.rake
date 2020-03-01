namespace :time_zone do
  task backpop: :environment do
    User.where(time_zone: nil).update_all(time_zone: "America/Chicago")
  end
end
