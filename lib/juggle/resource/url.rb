class Juggle::Resource::Url < Juggle::Resource
  
  def startup
    `open #{@opts[:url]}`
  end
  
end