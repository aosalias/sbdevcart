namespace :sbdevcart do
  desc "load sbdev cart seeds"
  task :seed => :environment do
    Sbdevcart::Engine.load_seed
  end
end
