class Juggle

  class Project
  
    # startup
    # teardown
    # external sites
    # issues
  
    attr_accessor :name
    attr_accessor :resources
    attr_accessor :cwd
  
  
    def initialize(name, cwd)
      @name = name
      @cwd = cwd
      @resources = {}
    end
    
    def to_jugfile
      {
        :name => @name,
        :cwd => @cwd,
        :resources => Hash[@resources.collect{|name,resource|
          [name, resource.to_jugfile] rescue nil
        }.compact]
      }
    end
  
    def self.from_jugfile(jugfile)
      obj = self.new(jugfile[:name], jugfile[:cwd])
      obj.resources = Hash[jugfile[:resources].collect{|name, r_jug|
        [name, Resource.from_jugfile(r_jug)]
      }]
      obj
    end
  
    def startup
      @resources.each{|name, rsrc|
        rsrc.startup if rsrc.autostart
      }
    end
  
    def teardown
      @resources.each{|name, rsrc|
        rsrc.teardown if rsrc.autostart
      }
    end
  
    def scan!
      # TODO: actually inject them!
      Resource.known_resources.each{|r|
        p r if r.scan
      }
    end
    
  end

end