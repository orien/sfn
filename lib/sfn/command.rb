require 'sfn'
require 'bogo-cli'

module Sfn
  class Command < Bogo::Cli::Command

    autoload :Create, 'sfn/command/create'
    autoload :Describe, 'sfn/command/describe'
    autoload :Destroy, 'sfn/command/destroy'
    autoload :Events, 'sfn/command/events'
    autoload :Export, 'sfn/command/export'
    autoload :Import, 'sfn/command/import'
    autoload :Inspect, 'sfn/command/inspect'
    autoload :List, 'sfn/command/list'
    autoload :Promote, 'sfn/command/promote'
    autoload :Update, 'sfn/command/update'
    autoload :Validate, 'sfn/command/validate'

    # Override to provide config file searching
    def initialize(cli_opts, args)
      unless(cli_opts[:config])
        cli_opts = cli_opts.to_hash.to_smash(:snake)
        discover_config(cli_opts)
      end
      super(cli_opts, args)
    end

    # @return [Smash]
    def config
      memoize(:config) do
        super
      end
    end

    protected

    # Start with current working directory and traverse to root
    # looking for a `.sfn` configuration file
    #
    # @param opts [Smash]
    # @return [Smash]
    def discover_config(opts)
      cwd = Dir.pwd.split(File::SEPARATOR)
      until(cwd.empty? || File.exists?(cwd.push('.sfn').join(File::SEPARATOR)))
        cwd.pop(2)
      end
      opts[:config] = cwd.join(File::SEPARATOR) unless cwd.empty?
      opts
    end

    # @return [Class] attempt to return customized configuration class
    def config_class
      klass_name = self.class.name.split('::').last
      if(Sfn::Config.const_defined?(klass_name))
        Sfn::Config.const_get(klass_name)
      else
        super
      end
    end

  end
end
