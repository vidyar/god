module God
  
  class Meddle < Base
    # drb
    attr_accessor :server
    
    # api
    attr_accessor :watches, :timer
    
    # Create a new instance that is ready for use by a configuration file
    def initialize(options = {})
      self.watches = []
      self.server  = Server.new(self, options[:host], options[:port])
      self.timer = Timer.new
    end
      
    # Instantiate a new, empty Watch object and pass it to the mandatory
    # block. The attributes of the watch will be set by the configuration
    # file.
    def watch
      w = Watch.new(self)
      yield(w)
      
      # ensure the new watch has a unique name
      unless @watches.select { |x| x.name == w.name }.empty?
        abort "Duplicate Watch with name '#{w.name}'"
      end
      
      # add to list of watches
      @watches << w
    end
    
    # Schedule all poll conditions and register all condition events
    def monitor
      @watches.each { |w| w.monitor }
    end
    
    # def monitor
    #   threads = []
    #   
    #   @watches.each do |w|
    #     threads << Thread.new do
    #       while true do
    #         w.run
    #         sleep self.interval
    #       end
    #     end
    #   end
    #   
    #   threads.each { |t| t.join }
    # end
  end
  
end