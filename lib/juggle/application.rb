# TODO: refactor and defuck

class Juggle
  
  class Application
    
    class << self
      
      def header
        str = "jug v#{Juggle::Version::STRING}"
        str += " -- [#{@jug.selected_project}]" if @jug.selected_project
        
        str += "\n"
      end
      
      def run!(*args)
      
        Juggle.log('Loading jugfile')
        @jug = Juggle::Jugfile.new
        @jug.load
        
        @current_project = @jug.projects[@jug.selected_project] if @jug.selected_project
      
        case args.first
        when 'add'
          raise ArgumentError, 'no project name specified' unless args[1]
          new_project = Juggle::Project.new(args[1], Dir.pwd)
          @jug.projects[args[1]] = new_project
        when 'edit'
          @jug.edit(args[1])
        when 'projects'
          list_projects(args)
        when 'scan'
          @current_project.scan! if @current_project
        when 'help'
          help(args)
        when /^r(esources)?$/
          resources_menu(args) # good god this is nasty
        when nil, '', ' '
          if @current_project
            list_resources
          else
            help(args)
          end
        else
          if @current_project and rsrc = @current_project.resources[args.first] then
            (rsrc.startup and return 0)
          end
          if @jug.projects[args.first] then
            puts "Switching projects to #{args.first}..."
            @jug.select_project(args.first)
          else
            help(args)
          end
        end
        
        @jug.save
        
        return 0
      end
      
      def help(args)
        if args[1] and args[1].match(/^r/) then
          puts "#{header}
          Resources:
            jug r types                       list all the types of resources we know about.
            jug r add [name] [type] [opts]    add a resource  to the current project
            jug r list                        list the resources for the current project
            jug r rm [name]                   remove a resource from the current project
            jug r [name] [startup|teardown]   startup or teardown a resource
            jug r [name] autostart [on|off]   set the autostart on a resource
          "
      
        else
          puts "#{header}        
  Juggle is a tool for managing different software projects. For more information, visit http://github.com/adrianpike/juggle
        
          Usage:
            jug                     list all known projects, or if in a project, resources
            jug projects                list all known projects
            jug [name]              switch to a given project or fire a resource in the current project
            jug add [name]          create a new project in this directory.
            jug edit [name]         edit the project's resources in your favorite editor in a nice manner.
            jug scan                scan all our resource types to see if they apply to this project
            jug resources           show the resources for this project
            jug r                   shorthand for resources!
            jug help r              go look here.
          "
        end
      end
      
      def resources_menu(args)
        case args[1]
        when 'types'
          Resource.known_resources.each{|known|
            puts known.kind + "\n"
          }
        when nil,'', 'list'
          list_resources
        else
          help(['','r'])
        end
      end
      
      def list_projects(args)
        puts header
        @jug.projects.each{|name, proj|
          puts name + ' - ' + proj.cwd + "\n"
        }
      end
      
      def list_resources
        puts "#{header}"
        @current_project.resources.each {|name, rsrc|
          puts [name,rsrc.kind,rsrc.opts].join(', ') + "\n"
        }
      end
      
    end
    
  end
end