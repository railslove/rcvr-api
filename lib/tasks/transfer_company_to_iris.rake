namespace :companies do
  task :update => :environment do
      Company.all.each {|company|
          company.iris_update
      }
  end
end