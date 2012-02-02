class Juggle
  
  class Resource

    attr_accessor :autostart
    attr_accessor :opts

    def initialize(opts = {}, autostart = false)
      @autostart = autostart
      @opts = opts
    end

    def kind
      self.class.kind
    end
    
    def self.kind
      self.to_s.split('::').last
    end

    def to_jugfile
      {
        :autostart => @autostart,
        :kind => kind,
        :opts => @opts
      }
    end

    def self.scan
      false
    end

    def startup
      Juggle.log('NOOP')
    end
    
    def teardown
      Juggle.log('NOOP')
    end

    
    def self.from_jugfile(jugfile)
      klass = self.const_get(jugfile[:kind])
      klass.new(jugfile[:opts], jugfile[:autostart])
    end

    def self.known_resources
       ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

  end
  
end