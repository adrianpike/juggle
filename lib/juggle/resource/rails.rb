class Juggle::Resource::Rails < Juggle::Resource
  
  def self.scan
    if FileTest.exist?("config/application.rb") then
      true
    else
      false
    end
  end
  
  def startup
    `rails s -d --pid \`pwd\`/rails_s.pid`
  end
  
  def teardown
    `kill $(cat ~/rails_s.pid)`
  end
  
end