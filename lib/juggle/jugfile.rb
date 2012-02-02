# - rvm, textmate
# - basecamp
# - stride (import/export projects)
# - github (import/export projects, issues)

class Juggle
  
  class Jugfile
    
    attr_accessor :projects
    attr_accessor :selected_project
    
    def initialize
      @projects = {}
      @selected_project = nil
      @editor = 'mate -w'
      @path = '~/.jugfile'
    end
    
    def load
      begin
        @jugfile = JSON.load(File.open(File.expand_path(@path))).with_indifferent_access
        @jugfile['projects'].each{|name, proj|
          @projects[name] = Project.from_jugfile(proj)
        } if @jugfile['projects']
        @selected_project = @jugfile['selected_project']
        @editor = @jugfile['editor']
        
      rescue Errno::ENOENT
        Juggle.log('Couldn\'t load jugfile at ' + @path)
      end
    end
    
    def save
      @jugfile = {
        :selected_project => @selected_project,
        :projects => Hash[@projects.collect {|name, proj|
          [name, proj.to_jugfile]
        }],
        :editor => @editor
      }
      File.open(File.expand_path(@path), 'w') do |f|
        f.write(@jugfile.to_json)
      end
    end
    
    def select_project(name)
      projects[selected_project].teardown if selected_project
      `cd #{projects[name].cwd}`
      @selected_project = name
      projects[name].startup
    end
    
    def edit(project)
      tmpfile = Tempfile.new(project)
      tmpfile.write(JSON.pretty_generate(@projects[project].to_jugfile))
      tmpfile.flush
      system("#{@editor} #{tmpfile.path}")
      tmpfile.rewind
      @projects[project] = Project.from_jugfile(JSON.load(tmpfile.read).with_indifferent_access)
      # TODO: handle the name change!
      tmpfile.close
      tmpfile.unlink
    end
    
  end
  
end